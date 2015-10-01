{% set already_done = False %}
{% if pillar.containerhosts %}
{% for master in pillar.containerhosts %}
{% if grains['host'] in pillar.containerhosts[master] and not already_done %}
{% set already_done = True %}
is_container:
  grains.present:
    - value: True
{% endif %}
{% endfor %}
{% endif %}
