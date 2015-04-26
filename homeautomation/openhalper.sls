openhalper_dependencies:
  pkg.installed:
    - pkgs:
      - python
      - python-flask
      - python-requests

openhalper_bin:
  file.managed:
    - name: /usr/local/bin/openhalper.py
    - source:
      - salt://homeautomation/openhalper.py

openhalper_service:
  file.managed:
    - name: /usr/lib/systemd/system/openhalper.service
    - source:
      - salt://homeautomation/openhalper.service

  service.running:
    - name: openhalper
    - enable: True
    - require:
      - file: openhalper_service
      - pkg: openhalper_dependencies
      - cmd: install-python-raspberry-gpio
    - watch:
      - file: openhalper_bin
      - file: openhalper_config

openhalper_config:
  file.managed:
    - name: /etc/openhalper.conf
    - source:
      - salt://homeautomation/openhalper_conf/{{ grains.host }}
      - salt://homeautomation/openhalper_conf/default
