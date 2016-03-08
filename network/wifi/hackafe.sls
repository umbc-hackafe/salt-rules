wpa_supplicant_conf:
  file.managed:
    - name: /etc/wpa_supplicant/wpa_supplicant-wext-wlan0.conf
    - source: salt://network/wifi/hackafe-wpa_supplicant.conf
    - require:
      - pkg: wpa_supplicant
Daemon-Reload:
  cmd.wait:
    - name: systemctl daemon-reload
    - cwd: /
    - watch:
      - file: wpa_supplicant_conf
