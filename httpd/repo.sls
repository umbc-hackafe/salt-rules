http:
  user.present:
    - password: '$6$otrZK5Pi$n341px6PP7Zn5q544j9C3/sn7Igby7ssxsxLV1/VYZ.wT20b03aia1JcQDDkZ9/LLtmxJle4L3HZ6XL2QOxaI.'
  ssh_auth.present:
    - user: http
    - source: salt://httpd/repo.key

password_auth:
  augeas.change:
    - context: /files/etc/ssh/sshd_config/
    - changes:
      - set Match[1]/Condition/User "http"
      - set Match[1]/Settings/PasswordAuthentication "yes"
      - set Match[1]/Settings/PermitEmptyPasswords "no"
