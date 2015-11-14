systemd-networkd:
  service.running:
    - enable: True

dhcpcd@{{ pillar.devname[grains['host']] }}:
  service.dead:
    - enable: False

dhcpcd:
  service.dead:
    - enable: False

{% set vlan_conf = salt['grains.filter_by']({
    'hackafe': {
      'vlans': [1, 2, 3, 4, 5, 6, 7],
      'use_vlans': True },
    'prgmr': {
      'vlans': [1],
      'use_vlans': False }
  }, default='hackafe', grain='location')
%}

{% for vlan in vlan_conf['vlans'] %}
/etc/systemd/network/br{{ vlan }}.netdev:
  file.managed:
    - source: salt://network/bridge/brX.netdev
    - template: jinja
    - context:
      vlan: {{ vlan }}

/etc/systemd/network/br{{ vlan }}.network:
  file.managed:
    - source: salt://network/bridge/brX.network
    - template: jinja
    - context:
      vlan: {{ vlan }}

{% if vlan_conf['use_vlans'] %}
/etc/systemd/network/{{ pillar.devname[grains['host']] }}.{{ vlan }}.netdev:
  file.managed:
    - source: salt://network/bridge/ethX.netdev
    - template: jinja
    - context:
      vlan: {{ vlan }}

/etc/systemd/network/{{ pillar.devname[grains['host']] }}.{{ vlan }}.network:
  file.managed:
    - source: salt://network/bridge/ethX.network
    - template: jinja
    - context:
      vlan: {{ vlan }}
{% endif %}
{% endfor %}

/etc/systemd/network/eth.network:
  file.managed:
    - source: salt://network/bridge/eth.network
    - template: jinja
    - context:
      vlans: {{ vlan_conf['vlans'] }}
      use_vlans: {{ vlan_conf['use_vlans'] }}
