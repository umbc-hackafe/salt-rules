{% set timezone = 'America/New_York' %}

timesyncd:
  file.managed:
    - name: /etc/systemd/timesyncd.conf
    - source:
      - salt://network/timesyncd.conf
  cmd.wait:
    - name: timedatectl set-ntp true
    - user: root
    - watch:
      - file: timesyncd
  service.running:
    - name: systemd-timesyncd
    - enable: True
    - require:
      - file: timesyncd-allowvirtual

# This is necessary in order to allow timesyncd to run on virtual machines.
timesyncd-allowvirtual:
  file.managed:
    - name: /etc/systemd/system/systemd-timesyncd.service.d/allowvirtual.conf
    - contents: "[Unit]\nConditionVirtualization="
    - makedirs: True
    - watch_in:
      - cmd: daemon-reload

timezone:
  cmd.run:
    - name: timedatectl set-timezone '{{ timezone }}'
    - user: root
    - unless: ls -l '/etc/localtime' | grep '{{ timezone }}'
