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

makepkg:
  user.present:
    - shell: /bin/bash
    - home: /tmp
    - system: True

install-python-raspberry-gpio:
  cmd.run:
    - name: su makepkg -lc '/bin/bash <(curl www.xn--hackaf-gva.net/pkgs/aur.sh) --needed --noconfirm -si python-raspberry-gpio'
    - require:
      - user: makepkg
