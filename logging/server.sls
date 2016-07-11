#redis:
#  pkg.installed:
#    - name: redis
#  service.running:
#    - enable: True
#    - reload: True
#    - watch:
#      - pkg: redis
#
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
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://logging/elasticsearch.yml
  service.running:
    - enable: True
    - watch:
      - pkg: elasticsearch

kibana:
  pkg.installed: []
  file.managed:
    - name: /etc/elasticsearch/kibana/kibana.yml
    - source: salt://logging/kibana.yml
  service.running:
    - enable: True
    - watch:
      - pkg: kibana
      - file: kibana
