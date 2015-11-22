python-pyserial:
  pkg.installed: []

python-flask:
  pkg.installed: []

/opt/lights:
  file.directory:
    - makedirs: True

lights-git:
  git.latest:
    - name: https://github.com/umbc-hackafe/lights.git
    - target: /opt/lights
    - require:
      - file: /opt/lights
      - pkg: git

lights-service:
  file.copy:
    - name: /usr/lib/systemd/system/lights.service
    - source: /opt/lights/lights.service
    - require:
      - git: lights-git
    - watch_in:
      - cmd: daemon-reload

lights:
  service.running:
    - enable: True
    - require:
      - file: lights-service
      - pkg: python-pyserial
      - pkg: python-flask
