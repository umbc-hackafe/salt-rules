expac:
  pkg.installed: []

sudo:
  pkg.installed: []

install-cower:
  cmd.run:
    - name: pacman -U http://www.hackafé.net/cower-latest.pkg.tar.gz
    - create: /usr/bin/cower
    - require: 
      - pkg: expac
      - pkg: sudo

install-pacaur:
  cmd.run:
    - name: pacman -U http://vegasix.hackafé.net/pacaur-latest.pkg.tar.gz
    - create: /usr/bin/pacaur
    - require: 
      - pkg: expac
      - pkg: sudo
      - cmd: install-cower
