rsyslog:
  pkg.installed:
    - name: rsyslog
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://logging/rsyslog.conf
  service.running:
    - name: rsyslog
    - enable: True
    - watch:
      - pkg: rsyslog
      - file: rsyslog
