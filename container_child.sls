{% if pillar.containerhosts %}
{% for container_list in pillar.containerhosts %}
{% if grains['host'] in container_list %}
is_container:
  grains.setval: True
{% endif %}
{% endfor %}
{% endif %}
