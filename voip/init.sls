{% if pillar.phone_mac_cisco %}
{% for mac in pillar.phone_mac_cisco %}
voip_{{ mac }}:
  file.managed:
    - name: /srv/tftp/CTLSEP{{ mac | upper }}.tlv
    - content: ""
    - mode: 644
{% endfor %}
{% endif %}
