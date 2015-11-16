{% set cron_pkg, cron_svc = salt['grains.filter_by']({
    'RedHat': ('vixie-cron', 'crond'),
    'Arch': ('cronie', 'cronie')},
  grain='os_family', default='Arch')
%}

{{ cron_pkg }}:
  pkg.installed

{{ cron_svc }}:
  service.running:
    - enable: True
    - require: {{ cron_pkg }}
