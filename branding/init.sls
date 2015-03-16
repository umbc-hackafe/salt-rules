motd_salt:
  file.managed:
    - name: /etc/motd
    - source:
      - salt://files/branding/motd.jinja
    - mode: 644
    - template: jinja

# motd_quote:
#   file.append:
#     - name: /etc/motd
#     - sources:
#       - file://files/branding/motd/{{ grains['host'] }}
#       - file://files/branding/motd/missing
#     - require:
#       - file: motd_salt
