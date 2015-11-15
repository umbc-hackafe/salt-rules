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
  file.absent

make-container:
  file.absent

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
/data/baseroot/etc/systemd/system/multi-user.target.wants/{{ service }}.service:
  file.symlink:
    - target: /usr/lib/systemd/system/{{ service }}.service
    - force: True
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
/etc/systemd/nspawn/{{ container }}.nspawn:
  file.managed:
    - source: salt://containers/X.nspawn
    - template: jinja
    - context:
      vlan: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'vlan']), 3) }}
      private_net: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'private_net']), True) }}
      bind_mounts: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'bind_mounts']), {}) }}
    - require:
      - file: /etc/systemd/nspawn
    - require_in:
      - service: {{container}}
{% endif %}

/var/lib/machines/{{container}}:
  file.directory:
    - makedirs: True

/data/overlay/{{container}}:
  file.directory:
    - makedirs: True

/data/work/{{container}}:
  file.directory:
    - makedirs: True

overlay-mount-{{container}}:
  mount.mounted:
    - fstype: overlay
    - name: /var/lib/machines/{{container}}
    - opts: rw,relatime,lowerdir=/data/baseroot,upperdir=/data/overlay/{{container}},workdir=/data/work/{{container}}
    - device: /var/lib/machines/{{container}}
    - persist: True
    - require:
      - file: /var/lib/machines/{{container}}
      - file: /data/overlay/{{container}}
      - file: /data/work/{{container}}

create-machine-id-{{container}}:
  cmd.run:
    - name: systemd-machine-id-setup --root=/var/lib/machines/{{container}}
    - unless: test -f /var/lib/machines/{{container}}/etc/machine-id
    - require:
      - mount: overlay-mount-{{container}}

{{container}}:
  service.running:
    - name: systemd-nspawn@{{container}}.service
    - enable: True
    - require:
      - mount: overlay-mount-{{container}}
      - cmd: create-machine-id-{{container}}
{% endfor %}
{% endif %}
