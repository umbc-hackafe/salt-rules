/opt/idiotic:
  file.absent: []

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
    - rev: {{ salt['grains.filter_by']({
    'idiotic': 'master',
    'sweetiebot': 'demo'},
    grain='host', default='idiotic') }}
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
    - source: salt://homeautomation/idiotic-conf/{{ grains.host }}.json
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
  pkg.latest:
    - name: idiotic-git
    - watch_in:
      - service: idiotic
  service.running:
    - enable: True
    - require:
      - pkg: idiotic
      - git: idiotic-config-repo
      - file: /etc/idiotic/conf.json
      - pkg: idiotic-dependencies
