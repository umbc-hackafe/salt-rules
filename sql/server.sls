postgresql:
  pkg.installed: []
  service.running:
    - enabled: True
    - require:
      - cmd: initdb
      - file: /var/lib/postgres/data/pg_hba.conf
      - file: /var/lib/postgres/data/postgresql.conf

initdb:
  cmd.run:
    - name: initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
    - unless: test "$(ls -A /var/lib/postgres/data)"
    - user: postgres
    - require:
      - pkg: postgresql

/var/lib/postgres/data/pg_hba.conf:
  file.managed:
    - source: salt://sql/pg_hba.conf
    - template: jinja
    - require:
      - cmd: initdb

/var/lib/postgres/data/postgresql.conf:
  file.managed:
    - source: salt://sql/postgresql.conf
    - require:
      - cmd: initdb
