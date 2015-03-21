{% if pillar.admins %}
{% for admin in pillar.admins %}
{{ admin }}:
  user.present: []
  ssh_auth.present:
    - user: {{ admin }}
    - source: salt://login/keys/{{ admin }}
{% endfor %}
{% endif %}

wheel:
  group.present:
    - name: wheel
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins %}
      - {{admin}}
      {% endfor %}
    {% endif %}
