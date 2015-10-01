add-repo:
{% if grains['os'] == 'Arch' %}
  cmd.run:
    - name: grep 'hackafe' /etc/pacman.conf || echo -e "[hackafe]\nSigLevel = Optional TrustAll\nServer = http://repo.hackafe.net/\$arch" >> /etc/pacman.conf
{% else %}
  cmd.run:
    - name: "true"
{% endif %}
