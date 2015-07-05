redis:
  pkg.installed:
    - name: redis
  service.running:
    - enable: True
    - reload: True
    - watch:
      - pkg: redis

logstash:
  pkg.installed:
    - name: logstash
  file.recurse:
    - name: /etc/logstash/conf.d
    - source: salt://logging/logstash.conf.d
  service.running:
    - name: logstash
    - enable: True
    - watch:
      - pkg: logstash

elasticsearch:
  pkg.installed: []
  service.running:
    - enable: True

kibana:
  pkg.installed: []
  file.managed:
    - name: /usr/share/webapps/kibana/config/kibana.yml
    - source: salt://logging/kibana.yml
  service.running:
    - enable: True
    - watch:
      - pkg: kibana
      - file: kibana
