transmission-cli:
  pkg.installed

transmission:
  service.running:
    - require:
      - file: transmission-conf
    - watch:
      - file: transmission-conf

transmission-conf:
  file.managed:
    - name: /var/lib/transmission/.config/transmission-daemon/settings.json
    - source: salt://torrent/settings.json
    - makedirs: True
    - require:
      - pkg: transmission-cli
