include:
  - monitor.server.db

ido2db:
  service.running:
    - enable: True
    - require:
      - sls: monitor.server.db

icinga2:
  service.running:
    - enable: True
    - require:
      - sls: monitor.server.db
