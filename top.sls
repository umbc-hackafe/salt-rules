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

  'cheerilee.xn--hackaf-gva.net':
    - audio

  'luna.xn--hackaf-gva.net':
    - audio
    - audio.pulse

  'scootaloo.xn--hackaf-gva.net':
    - network.wifi
    - network.wifi.rtl-8192
