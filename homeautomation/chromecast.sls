include:
  - homeautomation.openhalper

chromecast_deps:
  pkg.installed:
    - pkgs:
      - python-google-api-python-client
      - castnow-git

/usr/local/bin/youcast.py:
  file.managed:
    - mode: 755
    - source:
      - salt:///homeautomation/youcast.py
    - require_in:
      - service: openhalper
    - require:
      - pkg: chromecast_deps
