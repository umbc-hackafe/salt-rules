import sys, subprocess

def espeak(*words):
    exitcode = subprocess.call(["espeak", ' '.join(words)])
    if exitcode == 0:
        return True
    else:
        return False

def stats():
    temperaturestrs = __salt__['mine.get']('*', 'sensor.temperature')
    print(temperaturestrs)
    temperatures = []
    for tempstr in temperaturestrs:
        try:
            temperatures.append(float(tempstr))
        except ValueError:
            print("Could not convert: '%s'" % tempstr)

    if temperatures:
        avgtemp = sum(temperatures)/len(temperatures)
    else:
        avgtemp = None
    return [avgtemp]
