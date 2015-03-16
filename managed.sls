salt-minion:
  service.running:
    - enable: True

salt-group:
  group.present:
    - name: salt
    - system: True
