find-prereqs:
  pkg.installed:
    - names:
      - golang
      - git
      - mosquitto

find-git:
  git.latest:
    - name: https://github.com/schollz/find.git:
    - target: /opt/find
    - require:
      - pkg: find-prereqs

build-find:
  cmd.run:
    - name: go get ./... && go build
    - cwd: /opt/find
    - require:
      - git: find-git
      - pkg: find-prereqs
    - onchanges:
      - git: find-git

/opt/find/mosquitto/conf:
  file.managed:
    - replace: False
    - contents: ''

/etc/mosquitto/mosquitto.conf:
  file.symlink:
    - target: /opt/find/mosquitto/conf
    - force: True
    - require:
      - pkg: find-prereqs

mosquitto:
  service.running:
    - enable: True
    - require:
      - pkg: find-prereqs
      - file: /etc/mosquitto/mosquitto.conf

/usr/lib/systemd/system/find.service:
  file.managed:
    - template: jinja
    - contents: |
        [Unit]
        Description=The Framework for Internal Navigation and Discovery
        [Service]
        Type=simple
        ExecStart=/bin/bash /opt/find/find -mqtt localhost:1883 -mqttadmin {{ salt['grains.get_or_set_hash']('mqtt:admin_user') }} -mqttadminpass {{ salt['grains.get_or_set_hash']('mqtt:admin_pass') }} -mosquitto $(pgrep mosquitto) -p :8080 0.0.0.0:8080
        Restart=always
        Requires=mosquitto.service
        After=mosquitto.service
        [Install]
        WantedBy=multi-user.target

find:
  service.running:
    - require:
      - file: /usr/lib/systemd/find.service
      - service: mosquitto
      - cmd: build-find
