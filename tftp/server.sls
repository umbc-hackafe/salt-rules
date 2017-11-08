{% set tftp_pkg, tftp_svc = salt['grains.filter_by']({
    'RedHat': ('tftp-server', 'tftp'),
    'Arch': ('tftp-hpa', 'tftpd')},
  grain='os_family', default='Arch')
%}

tftp-package:
  pkg.installed:
  - name: {{ tftp_pkg }}

/srv/tftp:
  file.directory:
    - user: root
    - group: tftp
    - dir_mode: 777
    - file_mode: 664
    - recurse:
      - group
    - makedirs: True
    - require:
      - group: tftp
      - user: tftp

/etc/conf.d/tftpd:
  file.managed:
    - source: salt://tftp/conf

tftp:
  group.present: []
  user.present:
    - shell: /bin/nologin
    - home: /srv/tftp
    - system: True
    - groups:
      - tftp

tftp-service:
  service.running:
    - name: {{ tftp_svc }}
    - enable: True
    - require:
      - pkg: {{ tftp_pkg }}
      - user: tftp
      - file: /srv/tftp
    - watch:
      - file: /etc/conf.d/tftpd
