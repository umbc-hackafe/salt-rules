cloud-config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/proxmox.conf
    - makedirs: True
    - source:
      - salt://cloud/cloud.conf
    - template: jinja

{% set deleted = salt['pillar.get']('cloud:deleted', []) %}
{% set defaults = salt['pillar.get']('cloud_defaults', {}) %}

{% for host, settings in salt['pillar.get']('cloud:instances', {}).items() %}
cloud-instance-{{ host }}:
{% if host in deleted %}
  cloud.absent
{% else %}
{% set full_settings = salt['dns.merge'](defaults, settings) %}
{% if salt['utils.dictlist_to_dict'](full_settings).get('mac_hash', False) %}{% set _ = full_settings.append({'hwaddr': salt['utils.gen_mac'](host)}) %}{% endif %}
{% if 'net0' not in salt['utils.dictlist_to_dict'](settings) %}{% set _ = full_settings.append({'net0': salt['utils.mknet'](**salt['utils.dictlist_to_dict'](full_settings))}) %}{% endif %}
  cloud.present: {{ salt['utils.filter_netparams'](full_settings + [{"name": host}])|yaml }}
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
