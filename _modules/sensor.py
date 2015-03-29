import subprocess

def _read_temp(pin=24):
    """Return (humidity, temperature) from the temp binary."""
    try:
        output = subprocess.check_output(["temp", str(pin)])
    except subprocess.CalledProcessError as e:
        if e.returncode == 127: # command not found
            return None
        else:
            raise e

    humidity, temperature = map(float, output.split(' '))
    if humidity == 0 and temperature == 0: # bad read from sensor
        return None

    return humidity, temperature

def temperature(pin=24):
    humidity, temperature = _read_temp(pin)
    return temperature

def humidity(pin=24):
    humidity, temperature = _read_temp(pin)
    return humidity
