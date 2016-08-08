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
    - network.bridge

  'vista.hackafe.net':
    - network.bridge

  'watson.hackafe.net':
    - network.bridge

  'salt.hackafe.net':
    - managed.master
    - cloud

  'cheerilee.hackafe.net':
    - audio
    - homeautomation.openhalper
    - music.pianobar

  'luna.hackafe.net':
    - audio
    - audio.pulse
    - cups
    - gcp
    - homeautomation.i2c
    - homeautomation.cec
    - homeautomation.chromecast
    - homeautomation.openhalper
    - ci.slave

  'scootaloo.hackafe.net':
    - homeautomation.openhalper
    - network.dhcp
    - network.wifi
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
    - homeautomation.lights
    - ci.slave

  'ci.hackafe.net':
    - ci.jenkins

  'cibuildslave1.hackafe.net':
    - ci.slave

  'logs.hackafe.net':
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
    - router.dhcp
    - router.networkd
    - router.bind
    - router.ddclient
    - router.radvd
    - backup.storage

  'cloud.hackafe.net':
    - login.reversessh
    - location.prgmr
    - router.bind

  'x86buildslave.hackafe.net':
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
    - gpg
    - finance

  'celestia.hackafe.net':
    - homeautomation.lights
    - ci.slave

  'twilight.hackafe.net':
    - homeautomation.lights
    - ci.slave

  'isumbcopen.hackafe.net':
    - isumbcopen
    - web

  'alexa.hackafe.net':
    - web

  'web.hackafe.net':
    - web
    - web.video

  'idiotic.hackafe.net':
    - homeautomation.idiotic

  'deschedule.hackafe.net':
    - deschedule

  'git.hackafe.net':
    - gogs

  'cibuildslave2.hackafe.net':
    - ci.slave

  'sweetiebot.hackafe.net':
    - homeautomation.idiotic

  'minecraft.hackafe.net':
    - minecraft

  'applejack.hackafe.net':
    - homeautomation.openhalper
    - network.dhcp
    - network.wifi
    - ci.slave

  'cheesesandwich.hackafe.net':
    - network.dhcp
    - network.wifi
