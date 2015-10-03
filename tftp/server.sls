tftp-hpa:
  pkg.installed

/srv/tftp:
  file.directory:
    - user: root
    - group: tftp
    - dir_mode: 775
    - file_mode: 664
    - recurse:
      - group
      - mode
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

tftpd:
  service.running:
    - enabled: True
    - require:
      - pkg: tftp-hpa
      - user: tftp
      - file: /etc/conf.d/tftpd
      - file: /srv/tftp