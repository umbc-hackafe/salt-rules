{% if pillar.phone_cisco %}
{% for phone_name, phone in pillar.phone_cisco.items() %}
voip_ctlsep_{{ phone.MAC }}:
  file.managed:
    - name: /srv/tftp/CTLSEP{{ phone.MAC | upper }}.tlv
    - source:
      - salt://voip/cisco_CTLSEP.tlv
    - mode: 644
voip_sep_{{ phone.MAC }}:
  file.managed:
    - name: /srv/tftp/SEP{{ phone.MAC | upper }}.cnf.xml
    - source:
      - salt://voip/cisco_SEP.cnf.xml
    - mode: 644

voip_sip_{{ phone.MAC }}:
  file.managed:
    - name: /srv/tftp/SIP{{ phone.MAC | upper }}.cnf
    - source:
      - salt://voip/cisco_SIP.cnf.jinja
    - mode: 644
    - template: jinja
    - context:
      phone_name: {{ phone_name }}
      phone: {{ phone }}
      intercom: {{ pillar.phone_intercom }}
{% endfor %}
{% endif %}
