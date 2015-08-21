alsa:
  pkg.installed:
    - name: alsa-utils

alsa_group:
  group.present:
    - name: audio
    - system: True
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins.keys() %}
      - {{admin}}
      {% endfor %}
    {% endif %}
