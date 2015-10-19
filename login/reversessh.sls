{% if pillar.reversessh_users %}
{% for username, properties in pillar.reversessh_users.items() %}
reversessh_{{ username }}:
  user.present:
    - name: {{ username }}
    - remove_groups: False
    {% for key, value in properties.items() %}
    - {{key}}: {{value}}
    {% endfor %}
  ssh_auth.present:
    - user: {{ username }}
    - source: salt://login/keys/{{ username }}
{% endfor %}
{% endif %}
