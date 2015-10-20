#!/usr/bin/env python3
import RPi.GPIO as gpio
import time
import sys

gpio.setmode(gpio.BOARD)
gpio.setup(12, gpio.OUT, initial=1)
gpio.setup(13, gpio.IN, pull_up_down=gpio.PUD_OFF)

if len(sys.argv) > 1 and sys.argv[1] == "trigger":
    gpio.output(12, 0)
    time.sleep(.1)
    gpio.output(12, 1)
elif len(sys.argv) > 1 and sys.argv[1] == "close":
    while gpio.input(13) != 0:
        gpio.output(12, 0)
        time.sleep(.1)
        gpio.output(12, 1)
        time.sleep(15)
elif len(sys.argv) > 1 and sys.argv[1] == "get":
    pass

print("False" if gpio.input(13) else "True")

gpio.cleanup(12)
