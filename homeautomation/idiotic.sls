idiotic-git-repo:
  git.latest:
    - name: https://github.com/idiotic/idiotic.git
    - target: /opt/idiotic
    - force_clone: True
    - target: /opt/idiotic
    - rev: develop
    - watch_in:
      - service: idiotic
      - cmd: install-idiotic

install-idiotic:
  cmd.run:
    - name: python3 setup.py install
    - cwd: /opt/idiotic
    - watch_in:
      - service: idiotic

/etc/idiotic/conf.yaml:
  file.managed:
    - source: salt://homeautomation/idiotic-conf/{{ grains.host }}.yaml
    - watch_in:
      - service: idiotic

/etc/systemd/system/idiotic.service:
  file.managed:
    - source: salt://homeautomation/idiotic.service
    - watch_in:
      - daemon-reload

idiotic-dependencies:
  pkg.installed:
    - pkgs:
      - python3-requests
      - python3-flask

idiotic:
  service.running:
    - enable: True
    - require:
      - git: idiotic-git-repo
      - file: /etc/idiotic/conf.yaml
      - file: /etc/systemd/system/idiotic.service
      - pkg: idiotic-dependencies
      - cmd: install-idiotic
