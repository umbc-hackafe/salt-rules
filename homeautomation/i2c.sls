include:
  - homeautomation.openhalper

modules:
  kmod.present:
    - name: i2c_dev
    - require_in:
      - service: openhalper
  kmod.present:
    - name: i2c_bcm2708
    - require_in:
      - service: openhalper

devicetree:
  pkg.installed:
    - name: lm_sensors
    - require_in:
      - service: openhalper

  augeas.change:
    - context: /boot/config.txt
    - changes:
      - set dtparam=i2c1=on
      - set dtparam=spi=on
    - require_in:
      - service: openhalper
