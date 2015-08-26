#!/usr/bin/env python3
import RPi.GPIO as gpio
import time
import sys

gpio.setmode(gpio.BOARD)
gpio.setup(11, gpio.OUT, initial=1)
gpio.setup(15, gpio.OUT, initial=1)

if len(sys.argv) > 1 and sys.argv[1] == "up":
    gpio.output(11, 0)
    time.sleep(.1)
    gpio.output(11, 1)
elif len(sys.argv) > 1 and sys.argv[1] == "down":
    gpio.output(15, 0)
    time.sleep(.1)
    gpio.output(15, 1)
elif len(sys.argv) > 1 and sys.argv[1] == "stop":
    gpio.output(11, 0)
    gpio.output(15, 0)
    time.sleep(.1)
    gpio.output(11, 1)
    gpio.output(15, 1)

gpio.cleanup()
