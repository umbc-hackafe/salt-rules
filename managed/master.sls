python-pygit2:
  pkg.installed:
    - name: python-pygit2-fix

salt-master:
  service.running:
    - enable: True
    - require:
      - pkg: python-pygit2

salt-master-config:
  file.managed:
    - name: /etc/salt/master
    - source:
      - salt://managed/master.yaml
    - template: jinja
    - watch_in:
      - service: salt-master

cloud-config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/proxmox.conf
    - makedirs: True
    - source:
      - salt://managed/cloud.conf
    - template: jinja
    - watch_in:
      - service: salt-master

salt-master-autosign:
  file.managed:
    - name: /etc/salt/autosign.conf
    - source:
      - salt://managed/autosign.conf
    - watch_in:
      - service: salt-master

/srv/reactor/update_fileserver.sls:
  file.managed:
    - makedirs: True
    - contents: |
      update_fileserver:
        runner.fileserver.update

{% set deleted = salt['pillar.get']('cloud:deleted', []) %}
{% set defaults = salt['pillar.get']('cloud:defaults', {}) %}

{% for host, settings in salt['pillar.get']('cloud:instances', {}).items() %}
cloud-instance-{{ host }}:
{% if host in deleted %}
  cloud.absent
{% else %}
  cloud.present: {{ salt['dns.merge'](settings, defaults)|yaml }}
{% endif %}
{% endfor %}

{% for host, settings in salt['pillar.get']('cloud:profile_instances', {}).items() %}
cloud-instance-{{ host }}:
{% if host in deleted %}
  cloud.absent
{% else %}
  cloud.profile: {{ settings|yaml }}
{% endif %}
{% endfor %}
