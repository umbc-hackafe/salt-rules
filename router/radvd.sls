/etc/radvd.conf:
  file.managed:
    - source: salt://router/radvd.conf

radvd:
  pkg.installed: []

radvd:
  service.running:
    - enable: True
    - require:
      - file: /etc/radvd.conf
      - pkg: radvd
