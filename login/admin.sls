{% if pillar.admins %}
{% for admin in pillar.admins %}
{{ admin }}:
  user.present:
    - remove_groups: False
  ssh_auth.present:
    - user: {{ admin }}
    - source: salt://login/keys/{{ admin }}
{% endfor %}
{% endif %}

sudo:
  group.present:
    - name: wheel
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins %}
      - {{admin}}
      {% endfor %}
    {% endif %}
  pkg.installed:
    - name: sudo
  file.managed:
    - name: /etc/sudoers
    - source: salt://login/sudoers
