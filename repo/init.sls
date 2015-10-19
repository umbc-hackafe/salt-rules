add-repo:
{% if grains['os'] == 'Arch' %}
  cmd.run:
    - name: echo -e "[hackafe]\nSigLevel = Optional TrustAll\nServer = http://repo.hackafe.net/\$arch" >> /etc/pacman.conf
    - unless: grep 'hackafe' /etc/pacman.conf
{% else %}
  cmd.run:
    - name: "true"
{% endif %}
