include:
  - homeautomation.openhalper

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

lm_sensors:
  pkg.installed:
    - require_in:
      - service: openhalper

boot-conf:
  augeas.change:
    - context: /files/boot/config.txt
    - changes:
      - set dtparam i2c1=on
      - set dtparam spi=on
    - lens: avahi
    - require_in:
      - service: openhalper
