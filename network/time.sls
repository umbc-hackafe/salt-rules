{% set timezone = 'America/New_York' %}

{% if salt['grains.get']('systemd:version') >= 213 %}
{% if salt['grains.get']('virtual') == "physical" %}
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
{% endif %}
{% else %}
ntpdate:
  pkg.installed: []
  service.running:
    - enable: True
{% endif %}

timezone:
  cmd.run:
    - name: timedatectl set-timezone '{{ timezone }}'
    - user: root
    - unless: ls -l '/etc/localtime' | grep '{{ timezone }}'
