minecraft-server:
  pkg.installed: []

minecraftd:
  service.running:
    - enable: True
    - require:
      - pkg: minecraft-server

minecraftd-backup.timer:
  service.running:
    - enable: True
    - require:
      - pkg: minecraft-server
