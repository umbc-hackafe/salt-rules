pulse:
  pkg.installed:
    - name: pulseaudio
    - pkgs:
      - pulseaudio
      - pulseaudio-alsa
    - require:
      - pkg: alsa
  user.present:
    - name: pulse
    - system: True
    - home: /var/run/pulse
    - groups:
      - audio
    - require:
      - group: alsa_group
  group.present:
    - name: pulse-access
    - system: True
    {% if pillar.admins %}
    - members:
      {% for admin in pillar.admins %}
      - {{admin}}
      {% endfor %}
    {% endif %}
