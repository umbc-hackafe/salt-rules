{% if pillar.admins %}
{% for admin, properties in pillar.admins.items() %}
{{ admin }}:
  user.present:
    - remove_groups: False
    {% for key, value in properties.items() %}
    - {{key}}: {{value}}
    {% endfor %}
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
      {% for admin in pillar.admins.keys() %}
      - {{admin}}
      {% endfor %}
    {% endif %}
  pkg.installed:
    - name: sudo
  file.managed:
    - name: /etc/sudoers
    - source: salt://login/sudoers

{% if pillar.rootpw %}
root:
  user.present:
    - remove_groups: False
{% if salt['grains.get']('host', None) in pillar.rootpw_overrides %}
    - password: {{ pillar.rootpw_overrides[salt['grains.get']('host', None)] }}
{% else %}
    - password: {{ pillar.rootpw }}
{% endif %}
{% endif %}
