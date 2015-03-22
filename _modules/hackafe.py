import sys, subprocess

def espeak(*words):
    exitcode = subprocess.call(["espeak"] + list(words))
    if exitcode == 0:
        return True
    else:
        return False
