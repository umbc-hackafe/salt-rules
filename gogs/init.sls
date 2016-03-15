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
      - cmd: set-gogs-cap

set-gogs-cap:
  cmd.run:
    - name: setcap 'cap_net_bind_service=+ep' /usr/share/gogs/gogs
    - unless: getcap /usr/share/gogs/gogs | grep 'cap_net_bind_service+ep'

sqlite:
  pkg.installed: []
