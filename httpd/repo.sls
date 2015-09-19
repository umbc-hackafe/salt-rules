http:
  ssh_auth.present:
    - user: http
    - source: salt://httpd/repo.key
