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

/usr/bin/dyndns:
  file.managed:
    - source: salt://router/bind/dyndns
    - template: jinja
    - mode: 755

/etc/systemd/system/dyndns.service:
  file.managed:
    - source: salt://router/bind/dyndns.service
    - template: jinja

/etc/systemd/system/dyndns.timer:
  file.managed:
    - source: salt://router/bind/dyndns.timer
    - template: jinja

dyndns.timer:
  service.running:
    - enable: True
    - require:
      - file: /usr/bin/dyndns
      - file: /etc/systemd/system/dyndns.timer
      - file: /etc/systemd/system/dyndns.service

/var/named:
  file.recurse:
    - source: salt://router/bind/zones
    - template: jinja
    - watch_in:
      - service: named
    - context:
      ignore_hosts:
        - vegafive.hackafe.net
        - mail.hackafe.net
