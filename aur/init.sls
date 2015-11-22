aur-prereqs:
{% if grains['osarch'] == 'x86_64' %}
  pkg.removed:
    - name: gcc
{% endif %}
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
      - {{ salt['grains.filter_by']({
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
