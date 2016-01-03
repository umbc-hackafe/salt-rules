ddclient:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - file: /etc/ddclient/ddclient.conf

/etc/ddclient/ddclient.conf:
  file.managed:
    - source: salt://router/ddclient.conf
    - template: jinja
