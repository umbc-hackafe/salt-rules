include:
  - augeas

openssh:
  pkg.installed:
    - name: {{ salt['grains.filter_by']({
      'Arch': 'openssh',
      'Debian': 'openssh-server'
    }, grain='os_family', default('Arch')) }}

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
