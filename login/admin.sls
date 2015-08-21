{% if pillar.admins %}
{% for admin, properties in pillar.admins.items() %}
{{ admin }}:
  user.present:
    - remove_groups: False
  ssh_auth.present:
    - user: {{ admin }}
    - source: salt://login/keys/{{ admin }}
    {% for key, value in properties.items() %}
    - {{key}}: {{value}}
    {% endfor %}
{% endfor %}
{% endif %}

sudo:
  group.present:
    - name: wheel
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins.keys() %}
      - {{admin}}
      {% endfor %}
    {% endif %}
  pkg.installed:
    - name: sudo
  file.managed:
    - name: /etc/sudoers
    - source: salt://login/sudoers
