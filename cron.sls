{% set cron_pkg = salt['grains.filter_by']({
    'RedHat': 'vixie-cron',
    'Arch': 'cronie'},
  grain='os_family', default='Arch')
%}

{{ cron_pkg }}:
  pkg.installed
