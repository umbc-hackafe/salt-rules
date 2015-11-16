{% set cron_pkg, cron_svc = salt['grains.filter_by']({
    'RedHat': ('vixie-cron', 'crond'),
    'Arch': ('cronie', 'cronie')},
  grain='os_family', default='Arch')
%}

cron-package:
  pkg.installed:
  - name: {{ cron_pkg }}


cron-service:
  service.running:
    - name: {{ cron_svc }}
    - enable: True
    - require: cron-package
