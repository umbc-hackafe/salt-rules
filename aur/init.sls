aur-prereqs:
  pkg.installed:
    - pkgs:
      - expac
      - sudo

install-cower:
  cmd.run:
    - name: pacman -U http://www.hackafé.net/pkgs/cower-latest.pkg.tar.gz
    - create: /usr/bin/cower
    - require: 
      - pkg: aur-prereqs

install-pacaur:
  cmd.run:
    - name: pacman -U http://www.hackafé.net/pkgs/pacaur-latest.pkg.tar.gz
    - create: /usr/bin/pacaur
    - require: 
      - pkg: aur-prereqs
      - cmd: install-cower
