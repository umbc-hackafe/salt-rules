/etc/ffserver.conf:
  file.managed:
    - source: salt:///web/ffserver.conf

/etc/systemd/system/ffserver.service:
  file.managed:
    - source: salt:///web/ffserver.service

/etc/systemd/system/ffmpeg.service:
  file.managed:
    - source: salt:///web/ffmpeg.service

ffserver:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/ffserver.service
      - file: /etc/systemd/system/ffmpeg.service
      - file: /etc/ffserver.conf

ffmpeg:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/ffserver.service
      - file: /etc/systemd/system/ffmpeg.service
      - service: ffserver
