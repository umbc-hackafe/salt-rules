install-python-raspberry-gpio:
  cmd.run:
    - name: su makepkg -lc 'pacman -Qi python-raspberry-gpio || /bin/bash <(curl hackafe.net/pkgs/aur.sh) --needed --noconfirm -si python-raspberry-gpio'
    - require:
      - user: makepkg
