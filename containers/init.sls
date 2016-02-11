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

/etc/systemd/system/make-container@.service:
  file.absent

/usr/bin/make-container:
  file.absent

{% set baseroot_install = salt['grains.filter_by']({
  'Arch': {
    'x86_64': 'pacstrap -cd /data/baseroot base salt-zmq',
    'i686': 'pacstrap -cd /data/baseroot_i686 -C /usr/local/etc/pacman_x86.conf base salt-zmq'
  },
  'RedHat': {
    'x86_64': 'yum --installroot=/data/baseroot -y install salt-minion',
    'i686': 'yum --installroot=/data/baseroot_i686 -y install salt-minion'
  },
}, grain='os_family', default='Arch')
%}


{% if grains['osarch'] == 'x86_64' %}
{% set arches = ['x86_64', 'i686'] %}
{% set basedirs = {'x86_64': '/data/baseroot', 'i686': '/data/baseroot_i686' } %}
{% if salt['grains.get']('os_family') == 'Arch' %}
/usr/local/etc/pacman_x86.conf:
  file.managed:
    - source: salt://containers/pacman_x86.conf
    - require_in:
      - cmd: install-baseroot-i686
{% endif %}
{% else %}
{% set arches = ['i686'] %}
{% set basedirs = { 'i686': '/data/baseroot' } %}
{% endif %}

{% for arch in arches %}
{% set baseroot = basedirs[arch] %}
{% if grains['os_family'] == 'RedHat' %}

{{ baseroot }}/etc/yum.repos.d/saltstack.repo:
  file.managed:
    - source: salt://containers/saltstack.repo
    - require:
      - cmd: create-base
{% else %}
arch-install-scripts:
  pkg.installed
{% endif %}

install-baseroot-{{ arch }}:
  cmd.run:
    - name: {{ baseroot_install[arch] }}
    - unless: test "$(ls -A {{ baseroot }})"
    - require:
{% if grains['os_family'] == 'Arch' %}
      - pkg: arch-install-scripts
{% endif %}
      - file: {{ baseroot }}

create-base-{{ arch }}:
  cmd.run:
    - name: true
    - unless: true
    - require:
      - cmd: install-baseroot-{{ arch }}

{{ baseroot }}/etc/machine-id:
  file.absent:
    - require_in: create-base

{{ baseroot }}/etc/securetty:
  file.append:
    - text: pts/0
    - require_in: create-base-{{ arch }}
    - makedirs: True

machines.target:
  service.enabled: []

{% for service in ["salt-minion", "systemd-networkd", "systemd-resolved"] %}
{{ baseroot }}/etc/systemd/system/multi-user.target.wants/{{ service }}.service:
  file.symlink:
    - target: /usr/lib/systemd/system/{{ service }}.service
    - force: True
    - require_in: create-base
    - makedirs: True
{% endfor %}

add-minion-config:
  file.managed:
    - name: {{ baseroot }}/etc/salt/minion.yaml
    - source: salt://managed/minion.yaml
    - makedirs: True
    - require:
      - file: {{ baseroot }}

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
{{ baseroot }}:
  file.directory:
    - makedirs: True

{% if pillar.containerhosts and grains['host'] in pillar.containerhosts %}
{% set extra_mount_opts = salt['pillar.get'](':'.join(['containerextras', grains['host'], 'mount-opts']), []) %}

{% for container in pillar.containerhosts[grains['host']] %}
{% set vlan_id = salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'vlan']), 3) %}
{% set network_num = vlan_id - 1 %}

{% set container_arch = salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'arch']), salt['grains.get']('osarch')) %}
{% set container_baseroot = basedirs[container_arch] %}

{% if salt['grains.get']('systemd:version') >= 219 %}
/etc/systemd/nspawn/{{ container }}.nspawn:
  file.managed:
    - source: salt://containers/X.nspawn
    - template: jinja
    - context:
      vlan: {{ vlan_id }}
      private_net: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'private_net']), True) }}
      bind_mounts: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'bind_mounts']), {}) }}
      exec_options: {{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'exec_options']), {}) }}
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
    - opts: rw,relatime,lowerdir={{ container_baseroot }},upperdir=/data/overlay/{{container}},workdir=/data/work/{{container}}{% if extra_mount_opts %},{{ ','.join(extra_mount_opts) }}{% endif %}
    - device: /var/lib/machines/{{container}}
    - persist: True
    - require:
      - file: /var/lib/machines/{{container}}
      - file: /data/overlay/{{container}}
      - file: /data/work/{{container}}

/var/lib/machines/{{container}}/etc/resolv.conf:
  file.managed:
    - contents:
      - domain hackafe.net
      - search hackafe.net.
      - nameserver 192.168.0.1
      - nameserver 2001:470:e591:0::1
    - require:
      - mount: overlay-mount-{{container}}
    - require_in:
      - service: {{container}}

create-minion-id-{{container}}:
  file.managed:
    - name: /var/lib/machines/{{container}}/etc/salt/minion_id
    - contents: {{container}}.{{ salt['pillar.get'](':'.join(['containerhosts', grains['host'], container, 'domain']), 'hackafe.net') }}
    - makedirs: True
    - require:
      - mount: overlay-mount-{{container}}
    - require_in:
      - service: {{container}}

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
