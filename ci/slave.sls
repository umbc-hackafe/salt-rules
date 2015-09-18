slave:
  user.present:
    - name: jenkins-slave
    - shell: /bin/sh
    - home: /var/jenkins
  ssh_auth.present:
    - user: jenkins-slave
    - source: salt://ci/jenkins-slave.key
