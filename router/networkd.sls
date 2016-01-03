systemd-networkd:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/network/eth.network
      - pkg: systemd-networkd

enableforwarding:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/enableforwarding.service
      - file: /usr/bin/enableforwarding

/etc/systemd/network:
  file.recurse:
    - source: salt://router/network
    - template: jinja
    - watch_in:
      - service: systemd-networkd

/etc/systemd/system/enableforwarding.service:
  file.managed:
    - source: salt://forwarding/enableforwarding.service
    - template: jinja

/usr/bin/enableforwarding:
  file.managed:
    - source: salt://forwarding/enableforwarding
    - template: jinja
    - mode: 755
