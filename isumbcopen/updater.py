#!/usr/bin/python3
from bs4 import BeautifulSoup
import re
from dateutil.parser import parse as dateparse
import datetime
import sys
import fileinput
import requests

debugging = False
usefile = False
usestdin = False

args = set(sys.argv)

def debug(string, *args, **kwargs):
    if debugging:
        print(str(string).format(*args, **kwargs))

if "debug" in args:
    debugging = True

if "-" in args:
    usestdin = True

for arg in args:
    if arg.startswith("file="):
        usefile = arg[5:]
        debugging = True

days = [w+"day" for w in ["mon", "tues", "wednes", "thurs", "fri", "satur", "sun"]]
months = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]
months.extend([m[:3] for m in months])
days.extend([w[:3] for w in days])

if usestdin:
    myumbc = ""
    for line in fileinput.input():
        myumbc += line.lower()
    banners = [myumbc]
elif usefile:
    with open(usefile) as f:
        myumbc = f.read().lower()
        banners = [myumbc]
else:
    try:
        req = requests.get("http://my.umbc.edu/discussions/14777", headers={"User-agent": "Chrome"})
    except:
        exit(1)

    if not req.ok:
        exit(1)

    myumbc = req.text
    soup = BeautifulSoup(myumbc)
    banners_normal = [item.text for item in soup.select(".stop.banner")]
    banners = [b.lower() for b in banners_normal]

    try:
        paws = soup.select("#paw-discussion-14777 span")[0]
        with open("/srv/http/isumbcopen.com/paws.txt", "w") as pawfile:
            pawfile.write(paws.text.strip())
    except:
        pass

def detail(t):
    try:
        with open("/srv/http/isumbcopen.com/detail.txt", "w") as details:
            details.write(t)
    except:
        pass

if banners:
    for text in banners:
        debug("text: {}", text.replace("\n", ""))
        datestring = " ".join([word for word in text.replace("noon", "12pm").split() if (re.match("[0-9]", word) and len(word) < 6) or word in days or any([word.startswith(d) for d in days]) or word in months])
        debug("date: {}", datestring)

        if not datestring or not datestring.strip():
            print("YEP")
            detail(' '.join(banners_normal))
            exit(0)

        time = dateparse(datestring)
        now = datetime.datetime.now()

        midnight = time.replace(hour=0, minute=0, second=0, microsecond=0)
        class_start = midnight.replace(hour=5)
        class_end = midnight.replace(hour=20,minute=30)

        class_end_before = midnight + datetime.timedelta(hours=-3,minutes=-30)
        class_start_after = midnight + datetime.timedelta(days=1, hours=5)

        if debugging:
            td = datetime.timedelta(minutes=30)
            day = datetime.timedelta(days=1)

            # YESTERDAY
            if "y_m" in args:
                debug("yesterday morning")
                now = now.replace(hour=7) - day
            elif "y_sm" in args:
                debug("yesterday after-school-morning")
                now = now.replace(hour=9) - day
            elif "y_a" in args:
                debug("yesterday afternoon")
                now = now.replace(hour=13) - day
            elif "y_e" in args:
                debug("yesterday evening")
                now = now.replace(hour=19) - day
            elif "y_n" in args:
                debug("yesterday night")
                now = now.replace(hour=23) - day

            # TODAY
            elif "n_m" in args:
                debug("now morning")
                now = now.replace(hour=7)
            elif "n_sm" in args:
                debug("now after-school-morning")
                now = now.replace(hour=9)
            elif "n_a" in args:
                debug("now afternoon")
                now = now.replace(hour=13)
            elif "n_e" in args:
                debug("now evening")
                now = now.replace(hour=19)
            elif "n_n" in args:
                debug("now night")
                now = now.replace(hour=23)

            # TOMORROW
            elif "t_m" in args:
                debug("tomorrow morning")
                now = now.replace(hour=7) + day
            elif "t_sm" in args:
                debug("tomorrow after-school-morning")
                now = now.replace(hour=9) + day
            elif "t_a" in args:
                debug("tomorrow afternoon")
                now = now.replace(hour=13) + day
            elif "t_e" in args:
                debug("tomorrow evening")
                now = now.replace(hour=19) + day
            elif "t_n" in args:
                debug("tomorrow night")
                now = now.replace(hour=23) + day

        debug("now: {:%c}", now)

        if "close" in text and "remain" not in text:
            detail("")
            debug("it's closing...")
            if class_start < now < time < class_end:
                debug("Because {:%c} < {:%c} < {:%c}", class_start, time, class_end)
                debug("    and {:%c} < {:%c} < {:%c}", now, time, class_end)
                print("UNTIL {}".format(str(int(time.strftime("%I")))))
            elif time < now < class_end:
                debug("Because {:%c} < {:%c} < {:%c}", time, now, class_end)
                print("NOPE")
            #elif now < class_end_before < time:
            #    print("FOR NOW")
            elif class_end_before < now < class_end:
                print("NOPE")
            else:
                debug("Because else")
                print("YEP")
        elif "open" in text or "delay" in text or ("remain" in text and "close" in text):
            detail("")
            if "open" in text:
                debug("says 'open'")
            if "delay" in text:
                debug("says 'delay'")

            if time == midnight and class_end_before < now < class_end:
                # If there's no date specified, then it probably is a message saying UMBC will be open throughout the day
                debug("it's at midnight")
                print("YEP")
            elif now > time and now < class_start_after:
                debug("Because {0:%c} > {1:%c} and {0:%c} < {2:%c}", now, time, class_start_after)
                print("YEP")
            elif class_end_before < now < time < class_end:
                debug("Because {:%c} < {:%c} < {:%c} < {:%c}", class_end_before, now, time, class_end)
                print("AFTER {}".format(str(int(time.strftime("%I")))))
            #elif time == midnight and now < class_end_before < time:
            #    print("FOR NOW")
            else:
                debug("Because else")
                print("YEP")
        else:
            print("YEP?")
            detail(' '.join(banners_normal))
else:
    debug("Because no banner")
    detail("")
    print("YEP")
