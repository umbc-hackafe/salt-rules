include:
  - homeautomation.openhalper

door_bin:
  file.managed:
    - name: /usr/local/bin/door.py
    - mode: 755
    - source:
      - salt://homeautomation/door.py
    - require_in:
      - service: openhalper

projector_bin:
  file.managed:
    - name: /usr/local/bin/projector.py
    - mode: 755
    - source:
      - salt://homeautomation/projector.py
    - require_in:
      - service: openhalper
