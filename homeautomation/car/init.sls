ipod:
  user.present:
    - home: /home/ipod
    - shell: /bin/bash
    - groups:
      - uucp
      - audio
      - lp

python-pip:
  pkg.installed

rpi-ipod-emulator:
  pkg.installed:
    - require:
      - pkg: python-pip
    - upgrade: True

getty@tty1.service:
  service.running:
    - enable: true

/etc/systemd/system/getty@tty1.service.d/override.conf:
  file.managed:
    - source: salt://homeautomation/car/override.conf

/etc/bluetooth/main.conf:
  file.managed:
    - source: salt://homeautomation/car/main.conf

bluetooth:
  service.running:
    - enable: True

/etc/udev/rules.d/50/bluetooth-hci-auto-poweron.rules:
  file.managed:
    - source: salt://homeautomation/car/bluetooth.rules
