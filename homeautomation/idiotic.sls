/opt/idiotic:
  git.latest:
    - source: https://github.com/umbc-hackafe/idiotic.git
    - require:
      - file: /opt/idiotic
    - watch_in:
      - service: idiotic
  file.directory:
    - makedirs: True

/usr/lib/systemd/system/idiotic.service:
  file.copy:
    - source: /opt/idiotic/contrib/idiotic.service
    - force: True
    - makedirs: True
    - require:
      - git: /opt/idiotic
    - watch_in:
      - cmd: daemon-reload
      - service: idiotic

/etc/idiotic:
  git.latest:
    - source; https://github.com/umbc-hackafe/idiotic-config.git
    - require:
      - file: /etc/idiotic
    - watch_in:
      - service: idiotic
  file.directory:
    - makedirs: True

/etc/idiotic/conf.json:
  file.managed:
    - source: salt://homeautomation/idiotic-conf.json
    - template: jinja
    - require:
      - file: /etc/idiotic
    - watch_in:
      - service: /etc/idiotic

idiotic:
  service.running:
    - enable: True
    - require:
      - git: /etc/idiotic
      - git: /opt/idiotic
      - file: /etc/idiotic/conf.json
