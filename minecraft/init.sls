minecraft-server:
  pkg.installed: []

minecraft:
  service.running:
    - enable: True
    - require:
      - pkg: minecraft-server
