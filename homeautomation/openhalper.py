#!/usr/bin/python

import sys
import flask
from time import sleep, time as now
import subprocess
import threading
import os.path
import json
import RPi.GPIO as GPIO
import requests

GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

try:
    raise TimeoutExpired()
except NameError:
    class TimeoutExpired(Exception):
        pass
    subprocess.TimeoutExpired = TimeoutExpired

try:
    subprocess.check_output(["true"], timeout=60)
except TypeError:
    subprocess.__real__check_output = subprocess.check_output
    def co_proxy(*args, **kwargs):
        if "timeout" in kwargs:
            del kwargs["timeout"]
        return subprocess.__real__check_output(*args, **kwargs)
    subprocess.check_output = co_proxy
except CalledProcessError:
    pass

try:
    raise FileNotFoundError()
except NameError:
    FileNotFoundError = IOError
except:
    pass

ACTIONS = {
    "say": {
        "exec": 'echo {[text]} | espeak --stdin --stdout | aplay',
        "parse": lambda r: "",
        "shell": True
    },
}

PORT = 8081

for conf_file in "/etc/openhalper.conf", os.path.expanduser("~/.config/openhalper.conf"), "./openhalper.conf":
    try:
        with open(conf_file) as f:
            conf = json.load(f)
            if "port" in conf:
                PORT = conf["port"]
            if "actions" in conf:
                ACTIONS.update(conf["actions"])
    except FileNotFoundError:
        pass
    except OSError:
        pass
    except IOError:
        pass

for action in ACTIONS.values():
    if "parse" in action and not callable(action["parse"]):
        action["parse"] = eval(action["parse"])

    if "validate" in action and not callable(action["validate"]):
        action["validate"] = eval(action["validate"])

if len(sys.argv) > 1:
    PORT = int(sys.argv[1])

NEXT_UPDATES = {}
CACHE = {}

def start_io():
    for name, item in ACTIONS.items():
        if 'type' in item and item['type'] == "gpio_out" or 'gpio_out' in item:
            GPIO.setup(item['pin'] if 'pin' in item else item['gpio_out'], GPIO.OUT)

        pud = GPIO.PUD_UP
        if 'pull' in item:
            if item['pull'].lower() == "down":
                pud = GPIO.PUD_DOWN
            elif item['pull'] == None:
                pud = None

        edge = GPIO.BOTH
        if 'edge' in item:
            if item['edge'].lower() == "falling":
                edge = GPIO.FALLING
            elif item['edge'].lower() == "rising":
                edge = GPIO.RISING

        if 'type' in item and item['type'] == "gpio_in" or 'gpio_in' in item:
            GPIO.setup(item['pin'] if 'pin' in item else item['gpio_in'], GPIO.IN, pull_up_down=pud)
            GPIO.add_event_detect(item['pin'] if 'pin' in item else item['gpio_in'], edge)

def init_intervals():
    for name, item in ACTIONS.items():
        if "interval" in item:
            NEXT_UPDATES[name] = now()

def do_action(name, **kwargs):
    item = ACTIONS[name]
    result = ""
    valid = True
    for i in range(item["tries"]) if "tries" in item else range(10):
        # Actions

        if "exec" in item:
            try:
                args = item["exec"]
                try:
                    args = [arg.format(kwargs) for arg in item["exec"]]
                except:
                    args = item["exec"].format(kwargs)

                result = subprocess.check_output(args, timeout=10, shell=(item["shell"] if "shell" in item else False)).decode('ascii')
            except subprocess.CalledProcessError as e:
                return "Error: {0}".format(e.returncode)
            except subprocess.TimeoutExpired:
                return "Timed out"
        elif "func" in item:
            result = item["func"](**kwargs)
        elif "gpio_in" in item or "type" in item and item['type'] == "gpio_in":
            result = GPIO.input(item['pin'] if 'pin' in item else item['gpio_in'])
        else:
            result = None

        if "parse" in item:
            result = item["parse"](result)

        # Don't do an action if the item doesn't validate, but
        # do keep trying
        if "validate" in item and not item["validate"](result):
            continue

        if name in CACHE and CACHE[name]["value"] == result:
            if "always" not in item or not item["always"]:
                break

        # Reactions
        if "put" in item:
            requests.put(item["put"], data=str(result))

        if "get" in item:
            requests.get(item["get"], data=str(result))

        if "post" in item:
            requests.post(item["post"], data=str(result))

        if "gpio_out" in item or "type" in item and item['type'] == "gpio_out":
            if 'state' in kwargs:
              result = bool(int(kwargs['state'][0]))
              GPIO.output(item['pin'] if 'pin' in item else item['gpio_out'], result)
            else:
              result = item['default']
            break

        # Don't keep trying if the result is valid
        if "validate" not in item or item["validate"](result):
            break
    else:
        valid = False

    return result, valid

def do_update():
    for name, time in NEXT_UPDATES.items():
        if time <= now():
            res, valid = do_action(name)
            if valid:
                CACHE[name] = {"value": res, "time": now()}
            else:
                print("do_update: Not caching request for {0}, it was invalid ({1})".format(name, res))
            NEXT_UPDATES[name] = now() + ACTIONS[name]["interval"]

    next = min([v for k, v in NEXT_UPDATES.items()] + [now() + 600])
    if next > now():
        sleep(max(next - now(), 0))

def handle_request(item, **args):
    if item in CACHE:
        if "cache" in ACTIONS[item]:
            if CACHE[item]["time"] + ACTIONS[item]["lifetime"] < now():
                return CACHE[item]["value"]

    res, valid = do_action(item, **args)
    if valid:
        CACHE[item] = {"value": res, "time": now()}
    else:
        print("handle_request: Not caching request for {0}, it was invalid ({1})".format(item, res))
    return str(res)

def update():
    start_io()
    init_intervals()
    while True:
        do_update()

updater = threading.Thread(target=update, name="ClimateUpdater")
updater.setDaemon(True)
updater.start()
        
app = flask.Flask(__name__)

@app.route('/<name>', methods=['GET', 'POST'])
def serve(name):
    if name in ACTIONS:
        args = flask.request.args
        return handle_request(name, **args)
    else:
        return "Page not found", 404

app.run('0.0.0.0', port=PORT, debug=False)
