asterisk:
  pkg.installed: []
#    - require:
#      - pkg: asterisk-espeak

  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: asterisk
      - file: /etc/asterisk
      - file: /var/lib/asterisk/sounds

asterisk-espeak:
  pkg.installed

at:
  pkg.installed

atd:
  service.running:
    - require:
      - pkg: at

python:
  pkg.installed

/etc/asterisk:
  file.recurse:
    - source: salt://asterisk/conf
    - template: jinja
    - watch_in:
      - service: asterisk

/var/lib/asterisk/sounds:
  file.recurse:
    - source: salt://asterisk/sounds

/var/lib/asterisk/moh:
  file.recurse:
    - source: salt://asterisk/moh

/usr/bin:
  file.recurse:
    - source: salt://asterisk/scripts
    - file_mode: '755'
