include:
  - augeas

http:
  user.present:
    - password: '$6$ws9gL7vJ$rG2TGsMWhY586fEglrYn6gPDeR4hPwo93k9CsTDw2f3LrGKXLSWCj56/S8tTcDkYWO334J3YmkaWIadyfxNno/'
  ssh_auth.present:
    - user: http
    - source: salt://httpd/repo.key

exclude:
  - sls: login.ssh

password_auth:
  augeas.change:
    - context: /files/etc/ssh/sshd_config/
    - changes:
      - set PasswordAuthentication "no"
      - set PermitEmptyPasswords "no"
      - set Match[1]/Condition/User "http"
      - set Match[1]/Settings/PasswordAuthentication "yes"
