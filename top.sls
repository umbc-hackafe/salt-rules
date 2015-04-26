base:
  '*':
    - managed
    - branding
    - login.admin
    - login.ssh
    - network.time
    - demo

  'vegasix.xn--hackaf-gva.net':
    - httpd.nginx
    - homeautomation.openhab
    - containers
    - network.bridge
    - aur

  'cheerilee.xn--hackaf-gva.net':
    - audio
    - homeautomation.openhalper
    - music.pianobar

  'luna.xn--hackaf-gva.net':
    - audio
    - audio.pulse

  'scootaloo.xn--hackaf-gva.net':
    - aur
    - homeautomation.openhalper
    - network.wifi
    - network.wifi.rtl-8192

  'vinyl.xn--hackaf-gva.net':
    - aur
    - homeautomation.openhalper

  'fluttershy.xn--hackaf-gva.net':
    - audio
    - network.wifi
    - network.wifi.rtl-8192

  'spike.xn--hackaf-gva.net':
    - aur
    - network.wifi
    - network.wifi.rtl-8192
    - homeautomation.openhalper

  'pinkie.xn--hackaf-gva.net':
    - aur
    - homeautomation.openhalper

  'icinga.xn--hackaf-gva.net':
    - aur
    - monitor.server
