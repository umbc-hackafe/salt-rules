add-repo:
{% if grains['os_family'] == 'Arch' %}
  cmd.run:
    - name: echo -e "[hackafe]\nSigLevel = Optional TrustAll\nServer = http://repo.hackafe.net/\$arch" >> /etc/pacman.conf
    - unless: grep 'hackafe' /etc/pacman.conf
{% else %}
  cmd.run:
    - name: "true"
{% endif %}

{% if grains['os_family'] == 'Arch' and grains['osarch'] == 'x86_64' %}
add-multilib:
  cmd.run:
    - name: echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    - unless: grep '^\[multilib\]' /etc/pacman.conf
{% endif %}
