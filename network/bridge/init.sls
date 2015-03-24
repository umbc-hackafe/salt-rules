systemd-networkd:
  service.enabled: []

/etc/systemd/network/br0.netdev:
  file.managed:
    - source: salt://network/bridge/br0.netdev

/etc/systemd/network/br0.network:
  file.managed:
    - source: salt://network/bridge/br0.network

/etc/systemd/network/eth.network:
  file.managed:
    - source: salt://network/bridge/eth.network
