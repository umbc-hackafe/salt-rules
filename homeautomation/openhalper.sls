openhalper_dependencies:
  pkg.installed:
    - pkgs:
      - python
      - python-flask
      - python-requests
      - python-raspberry-gpio

openhalper_bin:
  file.managed:
    - name: /usr/local/bin/openhalper.py
    - mode: 755
    - source:
      - salt://homeautomation/openhalper.py

temp_bin:
  file.managed:
    - name: /usr/local/bin/temp
    - mode: 755
    - source:
      - salt://homeautomation/temp

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
    - watch:
      - file: temp_bin
      - file: openhalper_bin
      - file: openhalper_config

openhalper_config:
  file.managed:
    - name: /etc/openhalper.conf
    - source:
      - salt://homeautomation/openhalper_conf/{{ grains.host }}
      - salt://homeautomation/openhalper_conf/default
