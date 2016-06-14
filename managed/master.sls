python-pygit2:
  pkg.installed:
    - name: python-pygit2-fix

salt-master:
  service.running:
    - enable: True
    - require:
      - pkg: python-pygit2

salt-master-config:
  file.managed:
    - name: /etc/salt/master
    - source:
      - salt://managed/master.yaml
    - template: jinja
    - watch_in:
      - service: salt-master

cloud-config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/proxmox.conf
    - makedirs: True
    - source:
      - salt://managed/cloud.conf
    - template: jinja
    - watch_in:
      - service: salt-master

salt-master-autosign:
  file.managed:
    - name: /etc/salt/autosign.conf
    - source:
      - salt://managed/autosign.conf
    - watch_in:
      - service: salt-master

/srv/reactor/update_fileserver.sls:
  file.managed:
    - makedirs: True
    - contents: |
      update_fileserver:
        runner.fileserver.update
