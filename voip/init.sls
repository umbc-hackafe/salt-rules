{% if pillar.phone_cisco %}
{% for phone_name, phone in pillar.phone_cisco.items() %}
{% set model = phone.get('model', 'cisco_7960') %}

{% if model == 'cisco_7960' %}
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
{% elif model == 'cisco_7904G' %}
voip_7940_{{ phone.MAC }}:
  file.managed:
    - name: /srv/tftp/ff{{ phone.MAC | lower }}
    - source: salt://voip/cisco_7904.cnf

voip_sep7940_{{ phone.MAC }}:
  file.managed:
    - name: /srv/tftp/SEP{{ phone.MAC | upper }}.cnf.xml
    - source: salt://voip/SEP_7904.cnf.xml
{% endif %}
{% endfor %}
{% endif %}

/srv/tftp/RINGLIST.DAT:
  file.managed:
    - source: salt://voip/RINGLIST.DAT

/srv/tftp/CTU24raw.raw:
  file.managed:
    - source: salt://voip/CTU24raw.raw
