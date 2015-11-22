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

  'watson.hackafe.net':
    - containers
    - network.bridge

  'salt.hackafe.net':
    - managed.master

  'cheerilee.hackafe.net':
    - audio
    - homeautomation.openhalper
    - music.pianobar

  'luna.hackafe.net':
    - audio
    - audio.pulse
    - cups
    - homeautomation.i2c
    - homeautomation.cec
    - homeautomation.chromecast
    - homeautomation.openhalper
    - ci.slave

  'scootaloo.hackafe.net':
    - homeautomation.openhalper
    - network.dhcp
    - network.wifi
    - network.wifi.rtl-8192
    - ci.slave

  'vinyl.hackafe.net':
    - homeautomation.openhalper

  'fluttershy.hackafe.net':
    - audio
    - network.wifi
    - network.wifi.rtl-8192

  'spike.hackafe.net':
    - homeautomation.openhalper
    - ci.slave

  'pinkie.hackafe.net':
    - homeautomation.openhalper

  'icinga.hackafe.net':
    - monitor.server

  'rarity.hackafe.net':
    - audio
    - homeautomation.openhalper
    - ci.slave

  'dash.hackafe.net':
    - homeautomation.sign
    - ci.slave

  'thegreatandpowerfultrixie.hackafe.net':
    - homeautomation.garage
    - homeautomation.openhalper
    - homeaetomation.lights
    - ci.slave

  'ci':
    - ci.jenkins

  'cibuildslave1.hackafe.net':
    - ci.slave

  'logs':
    - logging.server

  'repo.hackafe.net':
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
    - location.prgmr

  'cibuildslave2.hackafe.net':
    - ci.slave

  'sql.hackafe.net':
    - sql.server

  'backup.hackafe.net':
    - backup.server

  'cibuildslave3.hackafe.net':
    - ci.slave

  'discord.hackafe.net':
    - homeautomation.openhalper

  'brain*.hackafe.net':
    - brains

  'asterisk.hackafe.net':
    - asterisk
    - cron

  'torrent.hackafe.net':
    - torrent

  'finance.hackafe.net':
    - aur
    - gpg
    - finance

  'celestia.hackafe.net':
    - homeautomation.lights
    - ci.slave

  'twilight.hackafe.net':
    - homeautomation.lights
