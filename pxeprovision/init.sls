/opt/pxe:
  file.directory:
    - makedirs: True

pxe-git:
  git.latest:
    - name: https://github.com/bitbyt3r/pxe.git
    - target: /opt/pxe
    - require:
      - file: /opt/pxe

pxe-service:
  file.copy:
    - name: /etc/systemd/system/pxe.service
    - source: /opt/pxe/pxe.service
    - force: True
    - require:
      - git: pxe-git
    - watch_in:
      - cmd: daemon-reload

hostnames:
  file.managed:
    - name: /opt/pxe/httproot/hostnames
    - source:
      - salt://pxeprovision/hostnames.jinja
    - template: jinja
    - require_in:
      - file: cloud-config

#pxe:
#  service.running:
#    - enable: True
#    - require:
#      - file: pxe-service
#      - file: hostnames
