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

install-i2c-tools:
  cmd.run:
    - name: su makepkg -lc 'pacman -Qi i2c-tools-svn || /bin/bash <(curl hackafe.net/pkgs/aur.sh) --needed --noconfirm -si i2c-tools-svn'
    - require:
      - user: makepkg
    - require_in:
      - service: openhalper

install-python-smbus:
  cmd.run:
    - name: su makepkg -lc 'pacman -Qi python-smbus || /bin/bash <(curl hackafe.net/pkgs/aur.sh) --needed --noconfirm -si python-smbus'
    - require:
      - user: makepkg
      - cmd: install-i2c-tools
    - require_in:
      - service: openhalper
