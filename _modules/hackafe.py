import sys, subprocess

def espeak(text):
    subprocess.call(["espeak", text])
