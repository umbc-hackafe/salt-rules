/opt/idiotic:
  file.absent: []

idiotic:
  pkg.latest:
    - watch_in:
      - service: idiotic

/etc/idiotic/modules:
  file.directory:
    - require:
      - pkg: idiotic
    - makedirs: True

idiotic-config-repo:
  git.latest:
    - name: https://github.com/umbc-hackafe/idiotic-config.git
    - force_clone: True
    - target: /etc/idiotic
    - require:
      - pkg: idiotic
    - watch_in:
      - service: idiotic

idiotic-webui-repo:
  git.latest:
    - name: https://github.com/umbc-hackafe/idiotic-webui.git
    - force_clone: True
    - target: /etc/idiotic/modules/webui
    - require:
      - file: /etc/idiotic/modules
    - watch_in:
      - service: idiotic

/etc/idiotic/conf.json:
  file.managed:
    - source: salt://homeautomation/idiotic-conf.json
    - template: jinja
    - require:
      - pkg: idiotic
      - git: idiotic-config-repo
    - watch_in:
      - service: idiotic

idiotic-dependencies:
  pkg.installed:
    - pkgs:
      - python-dateutil
      - python-psycopg2
      - python-py-wink-git
      - python-pygal
      - python-pyalexa
      - python-requests
      - python-sqlalchemy

idiotic:
  service.running:
    - enable: True
    - require:
      - pkg: idiotic
      - git: idiotic-config-repo
      - file: /etc/idiotic/conf.json
      - pkg: idiotic-dependencies
