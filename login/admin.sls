{% if pillar.admins %}
{% for admin in pillar.admins %}
{{ admin }}:
  user.present:
    - groups:
      - salt
      - wheel
      - audio
      - video
  ssh_auth.present:
    - user: {{ admin }}
    - source: salt://login/keys/{{ admin }}
{% endfor %}
{% endif %}
