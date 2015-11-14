/etc/systemd/system/systemd-nspawn@.service:
{% if salt['grains.get']('systemd:version') < 219 %}
  file.managed:
    - source: salt://containers/systemd-nspawn@.service
    - require:
      - file: make-container@.service
    - watch_in:
      - cmd: daemon-reload
{% else %}
  file.absent
{% endif %}

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

{% set baseroot_install = salt['grains.filter_by']({
  'Arch': 'pacstrap -cd /data/baseroot base salt-zmq',
  'RedHat': 'yum --installroot=/data/baseroot -y install salt-minion'
  }, grain='os_family', default='Arch')
%}

{% if grains['os_family'] == 'RedHat' %}
/data/baseroot/etc/yum.repos.d/saltstack.repo:
  file.managed:
    - source: salt://containers/saltstack.repo
    - require:
      - cmd: create-base
    - require-in:
      - file: make-container
{% else %}
arch-install-scripts:
  pkg.installed
{% endif %}

install-baseroot:
  cmd.run:
    - name: {{ baseroot_install }}
    - unless: test "$(ls -A /data/baseroot)"
    - require:
{% if grains['os_family'] == 'Arch' %}
      - pkg: arch-install-scripts
{% endif %}
      - file: /data/baseroot

create-base:
  cmd.run:
    - name: true
    - unless: true
    - require:
      - cmd: install-baseroot

/data/baseroot/etc/machine-id:
  file.absent:
    - require_in: create-base

/data/baseroot/etc/securetty:
  file.append:
    - text: pts/0
    - require_in: create-base

{% for service in ["salt-minion", "systemd-networkd", "systemd-resolved"] %}
/etc/systemd/system/multi-user.target.wants/{{ service }}.service:
  file.symlink:
    - target: /data/baseroot/usr/lib/systemd/system/{{ service }}.service
    - require_in: create-base
{% endfor %}

add-minion-config:
  file.managed:
    - name: /data/baseroot/etc/salt/minion.yaml
    - source: salt://managed/minion.yaml
    - require:
      - file: /data/baseroot

{% if salt['grains.get']('systemd:version') >= 219 %}
/etc/systemd/nspawn:
  file.directory:
    - makedirs: True
{% endif %}

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
{% if salt['grains.get']('systemd:version') >= 219 %}
make-{{container}}:
  cmd.run:
    - name: systemctl start make-container@{{container}}
    - require:
      - file: make-container@.service
/etc/systemd/nspawn/{{ container }}.nspawn:
  file.managed:
    - source: salt://containers/X.nspawn
    - template: jinja
    - context:
      vlan: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'vlan']), 3) }}
      private_net: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'private_net']), True) }}
    - require:
      - file: /etc/systemd/nspawn
      - cmd: make-{{container}}
    - require_in:
      - service: {{container}}
{% endif %}
{{container}}:
  service.running:
    - name: systemd-nspawn@{{container}}.service
    - enable: True
{% endfor %}
{% endif %}
