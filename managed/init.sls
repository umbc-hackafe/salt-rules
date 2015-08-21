salt-minion:
  service.running:
    - enable: True
    - watch:
      - file: highstate-schedule

puppet:
  service.dead:
    - enable: False

salt-group:
  group.present:
    - name: salt
    - system: True
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins.keys() %}
      - {{admin}}
      {% endfor %}
    - require:
      {% for admin in pillar.admins.keys() %}
      - user: {{admin}}
      {% endfor %}
    {% endif %}

highstate-schedule:
  file.managed:
    - name: /etc/salt/minion.d/highstate
    - source:
      - salt://managed/scheduled-highstate

daemon-reload:
  cmd.wait:
    - name: systemctl daemon-reload
    - user: root
    - group: root
