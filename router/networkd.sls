systemd-networkd:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/network

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
      - cmd: restart-he-tunnel

/etc/systemd/system/enableforwarding.service:
  file.managed:
    - source: salt://router/forwarding/enableforwarding.service
    - template: jinja

/usr/bin/enableforwarding:
  file.managed:
    - source: salt://router/forwarding/enableforwarding
    - template: jinja
    - mode: 755

restart-he-tunnel:
  cmd.wait:
    - name: ip link del he-ipv6
    - watch_in:
      - service: systemd-networkd
