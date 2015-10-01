{% if pillar.containerhosts %}
{% for master in pillar.containerhosts %}
{% if grains['host'] in pillar.containerhosts[master] %}
is_container:
  grains.present:
    - value: True
{% endif %}
{% endfor %}
{% endif %}
