python-dateutil:
  pkg.installed: []

python-beautifulsoup4:
  pkg.installed: []

python-requests:
  pkg.installed: []

updater-service:
  file.managed:
    - name: /usr/lib/systemd/isumbcopenupdater.service
    - source: salt://isumbcopen/updater.service
    - require_in:
      - service: isumbcopenupdater.timer
    - watch_in:
      - cmd: daemon-reload

updater-timer:
  file.managed:
    - name: /usr/lib/systemd/system/isumbcopenupdater.timer
    - source: salt://isumbcopen/updater.timer
    - require_in:
      - service: isumbcopenupdater.timer
    - watch_in:
      - cmd: daemon-reload

/usr/local/bin/updater_wrapper:
  file.managed:
    - source: salt://isumbcopen/updater_wrapper
    - mode: 755
    - require_in:
      - service: isumbcopenupdater.timer

/usr/local/bin/updater.py:
  file.managed:
    - source: salt://isumbcopen/updater.py
    - mode: 755
    - require_in:
      - service: isumbcopenupdater.timer

isumbcopenupdater.timer:
  service.running:
    - enable: True
    - require:
      - pkg: python-dateutil
      - pkg: python-beautifulsoup4
      - pkg: python-requests
