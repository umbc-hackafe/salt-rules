dhcpd:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - file: /etc/dhcpd.conf

/etc/dhcpd.conf:
  file.managed:
    - source: salt://router/dhcpd.conf
    - template: jinja
