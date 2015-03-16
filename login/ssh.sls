openssh:
  pkg.installed

sshd:
  service.running:
    - enable: True
    - require:
      - pkg: openssh
