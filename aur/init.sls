aur-prereqs:
  pkg.installed:
    - pkgs:
      - expac
      - sudo

makepkg_sudoers_d:
  file.managed:
    - name: /etc/sudoers.d/90makepkg
    - mode: 0440
    - source: salt://aur/makepkg-sudoers.d
    - require:
      - pkg: aur-prereqs

install-cower:
  cmd.run:
    - name: pacman --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/cower-latest-{{grains['osarch']}}.pkg.tar.xz
    - create: /usr/bin/cower
    - require: 
      - pkg: aur-prereqs
      - file: makepkg_sudoers_d

install-pacaur:
  cmd.run:
    - name: pacman --noconfirm -U http://www.xn--hackaf-gva.net/pkgs/pacaur-latest-any.pkg.tar.xz
    - create: /usr/bin/pacaur
    - require: 
      - pkg: aur-prereqs
      - cmd: install-cower

makepkg:
  user.present:
    - shell: /bin/bash
    - home: /tmp
    - system: True

python-raspberry-gpio:
  pkg.installed:
    - provider:
      - cmd: su makepkg '/usr/bin/pacaur --noconfirm --noedit -S python-raspberry-gpio'
    - require:
      - pkg: install-pacaur
      - user: makepkg
