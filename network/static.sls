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
