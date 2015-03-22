wpa_supplicant_conf:
  file.managed:
    - name: /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
    - source: salt://network/wifi/hackafe-wpa_supplicant.conf
    - require:
      - pkg: wpa_supplicant
