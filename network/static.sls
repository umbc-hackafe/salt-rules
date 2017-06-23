systemd.network:
  file.managed:
    - name: /etc/systemd/network/ens18.network
    - source:
      - salt://network/ens18.jinja
    - template: jinja

systemd-networkd:
  service.running:
    - enable: True
    - require:
      - file: systemd.network

systemd-resolved:
  service.running:
    - enable: True
    - require:
      - service: systemd-networkd
      - file: /etc/resolv.conf

/etc/resolv.conf:
  file.symlink:
    - target: /run/systemd/resolve/resolv.conf
