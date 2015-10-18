base:
  '*':
    - managed
    - managed.update
    - branding
    - login.admin
    - login.ssh
    - network.time
    - git
    - repo
    - containerchild
    - logging.client

  'vegasix.hackafe.net':
    - httpd.nginx
    - containers
    - network.bridge
    - aur

  'watson.hackafe.net':
    - httpd.nginx
    - containers
    - network.bridge
    - voip
    - aur

  'cheerilee.hackafe.net':
    - audio
    - aur
    - homeautomation.openhalper
    - music.pianobar

  'luna.hackafe.net':
    - audio
    - audio.pulse
    - cups
    - aur
    - homeautomation.i2c
    - homeautomation.cec
    - homeautomation.chromecast
    - homeautomation.openhalper
    - ci.slave

  'scootaloo.hackafe.net':
    - aur
    - homeautomation.openhalper
    - network.dhcp
    - network.wifi
    - network.wifi.rtl-8192

  'vinyl.hackafe.net':
    - aur
    - homeautomation.openhalper

  'fluttershy.hackafe.net':
    - audio
    - network.wifi
    - network.wifi.rtl-8192

  'spike.hackafe.net':
    - aur
    - homeautomation.openhalper
    - ci.slave

  'pinkie.hackafe.net':
    - aur
    - homeautomation.openhalper

  'icinga.hackafe.net':
    - aur
    - monitor.server

  'rarity.hackafe.net':
    - aur
    - audio
    - homeautomation.openhalper
    - ci.slave

  'dash.hackafe.net':
    - aur
    - homeautomation.sign
    - homeautomation.openhalper
    - ci.slave

  'thegreatandpowerfultrixie.hackafe.net':
    - aur
    - homeautomation.garage
    - homeautomation.openhalper

  'ci':
    - ci.jenkins

  'ci-buildslave1.hackafe.net':
    - ci.slave

  'logs':
    - logging.server

  'ldap.hackafe.net':
    - aur

  'repo.hackafe.net':
    - aur
    - httpd.darkhttpd
    - httpd.repo

  'unifi.hackafe.net':
    - network.unifi

  'tftp.hackafe.net':
    - tftp.server
    - voip

  'print.hackafe.net':
    - cups

  'vegafive.hackafe.net':
    - containers
    - network.bridge
    - backup.storage

  'cloud.hackafe.net':
    - login.reversessh

  'cibuildslave2.hackafe.net':
    - aur
    - ci.slave

  'sql.hackafe.net':
    - sql.server

  'backup.hackafe.net':
    - backup.server
