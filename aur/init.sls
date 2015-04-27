aur-prereqs:
  pkg.installed:
    - pkgs:
      - expac
      - sudo
      - autoconf
      - automake
      - binutils
      - bison
      - fakeroot
      - file
      - findutils
      - flex
      - gawk
      - gcc
      - gettext
      - grep
      - groff
      - gzip
      - libtool
      - m4
      - make
      - pacman
      - patch
      - pkg-config
      - sed
      - sudo
      - texinfo
      - util-linux
      - which

makepkg_sudoers_d:
  file.managed:
    - name: /etc/sudoers.d/90makepkg
    - mode: 0440
    - source: salt://aur/makepkg-sudoers.d
    - require:
      - pkg: aur-prereqs

install-cower:
  cmd.run:
    - name: pacman --needed --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/cower-latest-{{grains['osarch']}}.pkg.tar.xz
    - create: /usr/bin/cower
    - require: 
      - pkg: aur-prereqs
      - file: makepkg_sudoers_d

install-pacaur:
  cmd.run:
    - name: pacman --needed --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/pacaur-latest-any.pkg.tar.xz
    - create: /usr/bin/pacaur
    - require: 
      - pkg: aur-prereqs
      - cmd: install-cower

makepkg:
  user.present:
    - shell: /bin/bash
    - home: /tmp
    - system: True

install-python-raspberry-gpio:
  cmd.run:
    - name: su makepkg -c '/usr/bin/pacaur --needed --noconfirm --noedit -S python-raspberry-gpio'
    - require:
      - cmd: install-pacaur
      - user: makepkg
