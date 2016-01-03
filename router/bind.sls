bind:
  pkg.installed: []

named:
  service.running:
    - enable: True
    - require:
      - file: /etc/named.conf
      - pkg: bind

/etc/named.conf:
  file.managed:
    - source: salt://router/bind/named.conf
    - template: jinja
