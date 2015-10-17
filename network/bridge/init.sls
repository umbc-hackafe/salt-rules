systemd-networkd:
  service.enabled: []

{% for vlan in [1, 2, 3, 4, 5, 6, 7] %}
/etc/systemd/network/br{{ vlan }}.netdev:
  file.managed:
    - source: salt://network/bridge/br{{ vlan }}.netdev
    - template: jinja
    - context:
      vlan: {{ vlan }}

/etc/systemd/network/br{{ vlan }}.network:
  file.managed:
    - source: salt://network/bridge/br0.network
    - template: jinja
    - context:
      vlan: {{ vlan }}

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
 {% endfor %}

/etc/systemd/network/eth.network:
  file.managed:
    - source: salt://network/bridge/eth.network
    - template: jinja
