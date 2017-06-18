python-pygit2:
  pkg.installed

salt-cloud:
  pkg.installed: {}

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

salt-master-firewalld:
  firewalld.service:
    - name: salt-master
    - ports:
      - 4505/tcp
      - 4506/tcp
