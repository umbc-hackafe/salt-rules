highstate-schedule:
  file.managed:
    - name: /etc/salt/minion.d/highstate.conf
    - source:
      - salt://managed/highstate.yaml
    - watch_in:
      - service: salt-minion
