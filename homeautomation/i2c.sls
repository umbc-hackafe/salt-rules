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

boot-conf:
  augeas.change:
    - context: /files/boot/config.txt
    - changes:
      - set dtparam=i2c1 on
      - set dtparam=spi on
    - lens: inifile.lns
    - require_in:
      - service: openhalper

install-python-smbus:
  cmd.run:
    - name: su makepkg -lc 'pacman -Qi python-smbus || /bin/bash <(curl hackafe.net/pkgs/aur.sh) --needed --noconfirm -si python-smbus'
    - require:
      - user: makepkg
    - require_in:
      - service: openhalper
