dhcp:
  pkg.installed: []

dhcpd:
  service.running:
    - enable: True
    - require:
      - file: /etc/dhcpd.conf
      - pkg: dhcp

/etc/dhcpd.conf:
  file.managed:
    - source: salt://router/dhcpd.conf
    - template: jinja
