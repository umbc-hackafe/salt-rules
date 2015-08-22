highstate-schedule:
  file.managed:
    - name: /etc/salt/minion.d/highstate.conf
    - source:
      - salt://managed/highstate.yaml
    - watched_in:
      - service: salt-minion
