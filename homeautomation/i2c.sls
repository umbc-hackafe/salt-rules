include:
  - homeautomation.openhalper
  - aur

i2c_dev:
  kmod.present:
    - persist: True
    - require_in:
      - service: openhalper

i2c_bcm2708:
  kmod.present:
    - persist: True
    - require_in:
      - service: openhalper

boot-conf:
  cmd.run:
    - name: |
        grep 'dtparam=i2c1=on' /boot/config.txt || echo 'dtparam=i2c1=on' >> /boot/config.txt
        grep 'dtparam=spi=on' /boot/config.txt || echo 'dtparam=spi=on' >> /boot/config.txt
    - require_in:
      - service: openhalper

i2c-tools-git:
  pkg.installed:
    - require_in:
      - service: openhalper

python-smbus-git:
  pkg.installed:
    - require_in:
      - service: openhalper
