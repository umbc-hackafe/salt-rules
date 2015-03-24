mariadb:
  pkg.installed: []
  service.running:
    - name: mysqld
    - enable: True
