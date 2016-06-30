cloud-config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/proxmox.conf
    - makedirs: True
    - source:
      - salt://cloud/cloud.conf
    - template: jinja

{% set deleted = salt['pillar.get']('cloud:deleted', []) %}
{% set defaults = salt['pillar.get']('cloud:defaults', {}) %}

{% for host, settings in salt['pillar.get']('cloud:instances', {}).items() %}
cloud-instance-{{ host }}:
{% if host in deleted %}
  cloud.absent
{% else %}
  cloud.present: {{ salt['utils.filter_netparams'](salt['dns.merge'](settings, defaults + [{"name": host}]))|yaml }}
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
