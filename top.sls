base:
  '*':
    - managed
    - branding
    - login.admin
    - login.ssh
    - demo

  'vegasix.xn--hackaf-gva.net':
    - httpd.nginx
    - homeautomation.openhab
    - containers
    - network.bridge

  'cheerilee.xn--hackaf-gva.net':
    - audio
    - music.pianobar

  'luna.xn--hackaf-gva.net':
    - audio
    - audio.pulse

  'scootaloo.xn--hackaf-gva.net':
    - network.wifi
    - network.wifi.rtl-8192

  'fluttershy.xn--hackaf-gva.net':
    - audio
    - network.wifi
    - network.wifi.rtl-8192
