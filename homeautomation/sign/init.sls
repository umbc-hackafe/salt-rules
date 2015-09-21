sign:
  user.present:
    - home: /home/sign
    - shell: /bin/bash

sign_repo:
  git.latest:
    - name: https://github.com/umbc-hackafe/sign-drivers.git
    - target: /opt/sign
    - require:
      - pkg: git

sign_reqs:
  pkg.installed:
    - pkgs:
      - python-raspberry-gpio
      - python-flask
      - python-pyserial
      - python-requests
      - python-scipy
      - python-twython
      - python-websocket-client

getty@tty1.service:
  service.running:
    - enable: true

/etc/systemd/system/getty@tty1.service.d/override.conf:
  file.managed:
    - source: salt://homeautomation/sign/override.conf

/etc/sudoers.d/90sign:
  file.managed:
    - mode: 0440
    - source: salt://homeautomation/sign/sudoers.d
