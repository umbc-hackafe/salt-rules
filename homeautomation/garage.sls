include:
  - openhalper

door_bin:
  file.managed:
    - name: /usr/local/bin/door.py
    - mode: 755
    - source:
      - salt://homeautomation/door.py
    - prereq;
      - openhalper.openhalper_service

projector_bin:
  file.managed:
    - name: /usr/local/bin/projector.py
    - mode: 755
    - source:
      - salt://homeautomation/projector.py
    - prereq:
      - openhalper.openhalper_service
