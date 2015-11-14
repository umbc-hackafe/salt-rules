asterisk:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: asterisk
      - file: /etc/asterisk

/etc/asterisk:
  file.recurse:
    - source: salt://asterisk/conf
    - template: jinja
    - watch_in:
      - service: asterisk
