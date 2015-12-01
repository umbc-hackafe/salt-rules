idiotic-repo:
  git.latest:
    - name: https://github.com/umbc-hackafe/idiotic.git
    - target: /opt/idiotic
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
      - git: idiotic-repo
    - watch_in:
      - cmd: daemon-reload
      - service: idiotic

idiotic-config-repo:
  git.latest:
    - name: https://github.com/umbc-hackafe/idiotic-config.git
    - target: /etc/idiotic
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
      - git: idiotic-repo
      - git: idiotic-config-repo
      - file: /etc/idiotic/conf.json
