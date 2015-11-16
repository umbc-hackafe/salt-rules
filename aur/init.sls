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
      #- {{ salt['grains.filter_by']({
        'x86_64': 'gcc-multilib',
        'i686': 'gcc'}, grain='osarch', default='i686') }}
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

makepkg:
  user.present:
    - shell: /bin/bash
    - home: /tmp
    - system: True
    - require:
      - file: makepkg_sudoers_d

cower:
  pkg.installed: []
  cmd.script:
    - source: salt://aur/aur.sh
    - user: makepkg
    - args: 'cower'
    - require:
      - pkg: aur-prereqs
      - user: makepkg
    - onfail:
      - pkg: cower

pacaur:
  pkg.installed: []
  cmd.script:
    - source: salt://aur/aur.sh
    - user: makepkg
    - args: 'pacaur'
    - require:
      - pkg: aur-prereqs
      - user: makepkg
    - onfail:
      - pkg: pacaur
