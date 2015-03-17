{% for user in ["dylan", "mark25", "sasha"] %}
{{ user }}:
  user.present:
    - groups:
      - salt
      - wheel
      - audio
      - video
  ssh_auth.present:
    - user: {{ user }}
    - source: salt://files/login/keys/{{ user }}
{% endfor %}
