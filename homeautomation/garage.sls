include:
  - openhalper

door_bin:
  file.managed:
    - name: /usr/local/bin/door.py
    - mode: 755
    - source:
      - salt://homeautomation/door.py
    - prereq;
      - service.running: openhalper

projector_bin:
  file.managed:
    - name: /usr/local/bin/projector.py
    - mode: 755
    - source:
      - salt://homeautomation/projector.py
    - prereq:
      - service.running: openhalper
