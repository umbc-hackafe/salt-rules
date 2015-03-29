timesyncd:
  file.managed:
    - name: /etc/systemd/timesyncd.conf
    - source:
      - salt://network/timesyncd.conf
  cmd.run:
    - name: timedatectl set-ntp true
    - user: root
    - watch:
      - file: timesyncd
  service.running:
    - name: systemd-timesyncd
    - enable: True

timezone:
  cmd.run:
    - name: timedatectl set-timezone 'America/New_York'
    - user: root
