#!/usr/bin/env python3
import random
import sign
import sys
import os

if len(sys.argv) <= 1:
    print("Usage: {} {} {}".format(sys.argv[0], "<start|finish>", "<extension>"))
    sys.exit()

display = sign.Sign("192.168.4.105", 8800)

if sys.argv[1] == "start":
    code = str(random.randrange(10000, 50000))
    print(code)
    display.new_message(code, name="super-alarm-" + sys.argv[2], effects=["bounce_x"])
    os.execlp("redial-alarm.sh", sys.argv[2], code)
elif sys.argv[1] == "finish":
    display.remove_message("super-alarm-" + sys.argv[2])
