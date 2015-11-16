{% if grains['os_family'] == 'Arch' %}
add-repo:
  file.append:
    - name: /etc/pacman.conf
    - text: "[hackafe]\nSigLevel = Optional TrustAll\nServer = http://repo.hackafe.net/$arch"
{% endif %}

{% if grains['os_family'] == 'Arch' and grains['osarch'] == 'x86_64' %}
add-multilib:
  file.append:
    - name: /etc/pacman.conf
    - text: "[multilib]\nInclude = /etc/pacman.d/mirrorlist"
{% endif %}
