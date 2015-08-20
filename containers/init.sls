{% if pillar.containerhosts and grains['host'] in pillar.containerhosts %}
{% for container in pillar.containerhosts[grains['host']] %}
{{container}}:
  service.running:
    - name: systemd-nspawn@{{container}}.service
    - enable: True
    - require:
      - file: /data/{{container}}
      - file: /data/overlay/{{container}}
      - file: /data/work/{{container}}

/data/{{container}}:
  file.directory: []
/data/overlay/{{container}}:
  file.directory: []
/data/work/{{container}}:
  file.directory: []

{% endfor %}
{% endif %}
