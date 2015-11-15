transmission-cli:
  pkg.installed

transmission:
  service.running

/var/lib/transmission/.config/transmission-daemon/settings.json:
  file.managed:
    - source: salt://torrent/settings.json
    - makedirs: True
    - require:
      - pkg: transmission-cli
