dylan:
  user.present:
    - fullname: Dylan Whichard
    - groups:
      - salt
      - wheel
  ssh_auth.present:
    - user: dylan
    - source: salt://files/keys/dylan

mark25:
  user.present:
    - fullname: Mark Murnane
    - groups:
      - salt
      - wheel
  ssh_auth.present:
    - user: mark25
    - source: salt://files/keys/mark25

sasha:
  user.present:
    - fullname: Alexander Bauer
    - groups:
      - salt
      - wheel
  ssh_auth.present:
    - user: sasha
    - source: salt://files/keys/sasha
