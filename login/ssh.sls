openssh:
  pkg.installed

sshd:
  service.running:
    - enable: True
    - require:
      - pkg: openssh
    - watch:
      - augeas: sshd
  augeas.change:
    - context: /files/etc/ssh/sshd_config
    - changes:
      - set PasswordAuthentication no
      - set PermitEmptyPasswords no
