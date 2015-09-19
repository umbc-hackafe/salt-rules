include:
  - aur

slave:
  user.present:
    - name: jenkins-slave
    - shell: /bin/sh
    - home: /var/jenkins
  ssh_auth.present:
    - user: jenkins-slave
    - source: salt://ci/jenkins-slave.key
  pkg.installed:
    - name: jre8-openjdk-headless

ci_sudoers_d:
  file.managed:
    - name: /etc/sudoers.d/90ci
    - mode: 0440
    - source: salt://ci/ci-sudoers.d
    - require:
      - sls: aur
