wpa_supplicant_conf:
  file.managed:
    - name: /etc/wpa_supplicant/wpa_supplicant-wext-wlan0.conf
    - source: salt://network/wifi/hackafe-wpa_supplicant.conf
    - require:
      - pkg: wpa_supplicant
wpa_supplicant_wext:
  file.managed:
    - name: /usr/lib/systemd/system/wpa_supplicant-wext@.service
    - source: salt://network/wifi/hackafe-wpa_supplicant-wext@.service
    - require:
      - pkg: wpa_supplicant
    - onchanges:
      - cmd.run:
        - name: "systemctl daemon-reload"
