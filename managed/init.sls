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
      {% for admin in pillar.admins %}
      - {{admin}}
      {% endfor %}
    {% endif %}

highstate-schedule:
  file.managed:
    - name: /etc/salt/minion.d/highstate
    - source:
      - salt://managed/scheduled-highstate
