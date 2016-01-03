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

/var/named:
  file.recurse:
    - source: salt://router/bind/zones
    - template: jinja
    - watch_in:
      - service: named
    - context:
      ignore_hosts:
        - vegasix.hackafe.net
        - mail.hackafe.net
