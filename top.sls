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
    - network.static
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
    - network.static
    - ci.jenkins

  'cibuildslave1.hackafe.net':
    - network.static
    - ci.slave

  'logs.hackafe.net':
    - network.static
    - logging.server

  'repo.hackafe.net':
    - network.static
    - httpd.darkhttpd
    - httpd.repo

  'unifi.hackafe.net':
    - network.static
    - network.unifi

  'tftp.hackafe.net':
    - network.static
    - tftp.server
    - voip

  'print.hackafe.net':
    - network.static
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
    - network.static
    - sql.server

  'backup.hackafe.net':
    - network.static
    - backup.server

  'cibuildslave3.hackafe.net':
    - ci.slave

  'discord.hackafe.net':
    - network.static
    - homeautomation.openhalper

  'brain*.hackafe.net':
    - network.static
    - brains

  'asterisk.hackafe.net':
    - network.static
    - asterisk
    - cron

  'torrent.hackafe.net':
    - network.static
    - torrent

  'finance.hackafe.net':
    - network.static
    - gpg
    - finance

  'celestia.hackafe.net':
    - homeautomation.lights
    - ci.slave

  'twilight.hackafe.net':
    - homeautomation.lights
    - ci.slave

  'isumbcopen.hackafe.net':
    - network.static
    - isumbcopen
    - web

  'alexa.hackafe.net':
    - network.static
    - web

  'web.hackafe.net':
    - network.static
    - web
    - web.video

  'idiotic.hackafe.net':
    - network.static
    - homeautomation.idiotic

  'deschedule.hackafe.net':
    - network.static
    - deschedule

  'git.hackafe.net':
    - network.static
    - gogs

  'cibuildslave2.hackafe.net':
    - network.static
    - ci.slave

  'sweetiebot.hackafe.net':
    - homeautomation.idiotic

  'minecraft.hackafe.net':
    - network.static
    - minecraft

  'applejack.hackafe.net':
    - homeautomation.openhalper
    - network.dhcp
    - network.wifi
    - ci.slave

  'cheesesandwich.hackafe.net':
    - network.dhcp
    - network.wifi
    - homeautomation.car

  'find.hackafe.net':
    - network.static
    - homeautomation.find

  'magbadges.hackafe.net':
    - swadges

  'twilio.jasonspriggs.com':
    - network.static

  'nfs.hackafe.net':
    - network.static
