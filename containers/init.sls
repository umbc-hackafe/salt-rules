systemd-nspawn@.service:
  file.managed:
    - name: /etc/systemd/system/systemd-nspawn@.service
    - source: salt://containers/systemd-nspawn@.service
    - require:
      - file: make-container@.service
    - watch_in:
      - cmd: daemon-reload

make-container@.service:
  file.managed:
    - name: /etc/systemd/system/make-container@.service
    - source: salt://containers/make-container@.service
    - require:
      - file: make-container
    - watch_in:
      - cmd: daemon-reload

make-container:
  file.managed:
    - name: /usr/bin/make-container
    - source: salt://containers/make-container.sh
    - mode: 755
    - require:
      - cmd: create-base
      - file: add-minion-config

arch-install-scripts:
  pkg.installed

{% set baseroot_install = salt['grains.filter_by']({
  'Arch': 'pacstrap -cd /data/baseroot base salt-zmq',
  'RedHat': 'yum --installroot=/data/baseroot -y install salt-minion
  }, grain='os_family', default='arch')
%}

{% if grains['os_family'] == 'RedHat' %}
/data/baseroot/etc/yum.repos.d/saltstack.repo:
  file.managed:
    - source: salt://containers/saltstack.repo
    - require:
      - cmd: create-base
    - require-in:
      - file: make-container
{% endif %}

create-base:
  cmd.run:
    - name: |
        {{ baseroot_install }}
        ln -s /data/baseroot/usr/lib/systemd/system/salt-minion.service /etc/systemd/system/multi-user.target.wants/salt-minion.service
        ln -s /data/baseroot/usr/lib/systemd/system/systemd-networkd.service /etc/systemd/system/multi-user.target.wants/systemd-networkd.service
        rm /data/baseroot/etc/machine-id
        grep 'pts/0' /data/baseroot/etc/securetty || echo 'pts/0' >> /data/baseroot/etc/securetty
    - unless: test "$(ls -A /data/baseroot)"
    - require:
      - pkg: arch-install-scripts
      - file: /data/baseroot

add-minion-config:
  file.managed:
    - name: /data/baseroot/etc/salt/minion.yaml
    - source: salt://managed/minion.yaml
    - require:
      - file: /data/baseroot

/data:
  file.directory: []
/data/overlay:
  file.directory:
    - makedirs: True
/data/work:
  file.directory:
    - makedirs: True
/data/baseroot:
  file.directory:
    - makedirs: True


{% if pillar.containerhosts and grains['host'] in pillar.containerhosts %}
{% for container in pillar.containerhosts[grains['host']] %}
{{container}}:
  service.running:
    - name: systemd-nspawn@{{container}}.service
    - enable: True

{% endfor %}
{% endif %}
