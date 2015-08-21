openhab:
  service.running:
    - enable: True
  group.present:
    - name: openhab
    - system: True
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins.keys() %}
      - {{ admin }}
      {% endfor %}
    {% endif %}
