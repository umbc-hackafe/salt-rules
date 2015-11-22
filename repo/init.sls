{% if grains['os_family'] == 'Arch' %}
add-repo:
  file.append:
    - name: /etc/pacman.conf
    - text: "[hackafe]\nSigLevel = Optional TrustAll\nServer = http://repo.hackafe.net/$arch"
    - watch_in:
      - cmd: sync-repos

{% if grains['osarch'] == 'x86_64' %}
add-multilib:
  file.append:
    - name: /etc/pacman.conf
    - text: "[multilib]\nInclude = /etc/pacman.d/mirrorlist"
    - watch_in:
      - cmd: sync-repos
{% endif %}

sync-repos:
  cmd.run:
    - name: pacman -Syy
{% endif %}
