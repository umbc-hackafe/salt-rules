orthogonalspace:
  user.present:
    - home: /var/lib/orthogonalspace
  postgres_database.present:
    - require:
      - service: postgresql
  postgres_user.present:
    - password: password
    - login: true
    - require:
      - service: postgresql
  postgres_privileges.present:
    - object_name: orthogonalspace
    - object_type: database
    - privileges: 
      - ALL
    - require:
      - postgres_database: orthogonalspace
      - postgres_user: orthogonalspace
  postgres_extension.present:
    - name: uuid-ossp
    - maintenance_db: orthogonalspace
    - require:
      - pkg: postgresql-contrib
postgresql-contrib:
  pkg.installed: []
postgresql-server:
  pkg.installed: []
postgresql:
  service.running:
    - enable: true
    - require:
      - pkg: postgresql-server
