include:
  - monitor.server.db

icinga2:
  service.running:
    - enable: True
    - require:
      - sls: monitor.server.db
