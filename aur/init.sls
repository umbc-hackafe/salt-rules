aur-prereqs:
  pkg.installed:
    - pkgs:
      - expac
      - sudo

install-cower:
  cmd.run:
    - name: pacman --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/cower-latest.pkg.tar.xz
    - create: /usr/bin/cower
    - require: 
      - pkg: aur-prereqs

install-pacaur:
  cmd.run:
    - name: pacman --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/pacaur-latest.pkg.tar.xz
    - create: /usr/bin/pacaur
    - require: 
      - pkg: aur-prereqs
      - cmd: install-cower
