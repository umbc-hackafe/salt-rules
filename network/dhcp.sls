dhcpcd:
  pkg.installed:
    - name: dhcpcd
  service.running:
    - name: dhcpcd
    - enable: True
    - require:
      - pkg: dhcpcd
