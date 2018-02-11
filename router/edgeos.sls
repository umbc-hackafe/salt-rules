/config/config.boot:
  file.managed:
    source:
      - salt://router/config.yaml
    template: jinja

/config/scripts/reload.sh:
  file.managed:
    source:
      - salt://router/reload.sh
    mode: 755
  cmd.run:
    onchanges:
      - file: /config/config.boot
    require:
      - file: /config/scripts/reload.sh
