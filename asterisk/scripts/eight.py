#!/usr/bin/env python3
import random
import sign
import os

display = sign.Sign("dash", 8800)

display.new_message("8   8   8   8", name="eight", lifetime=1, priority=1)
