pianobar:
  pkg.installed: []

{% if pillar.pianobar_users %}
{% for user in pillar.pianobar_users %}
pianobar_config_{{user.name}}:
  file.managed:
    - name: /home/{{user.name}}/.config/pianobar/config
    - source: salt://music/pianobar.jinja
    - makedirs: True
    - user: {{user.name}}
    - group: {{user.name}}
    - context:
        user: {{user}}
    - require:
      - user: {{user.name}}
{% endfor %}
{% endif %}
