gogs:
  pkg.installed: []
  file.managed:
    - name: /srv/gogs/conf/app.ini
    - source: salt://gogs/app.ini
    - require:
      - pkg: gogs
    - template: jinja
    - watch_in:
      - service: gogs
  service.running:
    - require:
      - pkg: gogs
      - pkg: sqlite
      - file: gogs

sqlite:
  pkg.installed: []

gogs-sudoers-d:
  file.managed:
    - name: /etc/sudoers.d/90gogs
    - mode: 0440
    - source: salt://gogs/gogs-sudoers.d
