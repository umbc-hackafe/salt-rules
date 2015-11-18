salt-master:
  service.running:
    - enable: True

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

/var/git/saltmaster:
  file.directory:
    - user: root
    - group: salt
    - dir_mode: 2775
    - file_mode: 664
    - recurse:
      - group
      - mode
    - makedirs: True
    - require:
      - group: salt-group
