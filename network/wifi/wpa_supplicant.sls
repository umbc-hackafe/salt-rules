wpa_supplicant:
  pkg.installed: []
  service.running:
    - name: wpa_supplicant@wlan0
    - enable: True
    - require:
      - pkg: wpa_supplicant
