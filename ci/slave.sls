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

{% if 'num_cpus' in grains %}
add-makeopts:
  file.append:
    - name: /etc/makepkg.conf
    - text: "MAKEOPTS=-j{{ grains['num_cpus'] }}"
{% endif %}

ci_sudoers_d:
  file.managed:
    - name: /etc/sudoers.d/90ci
    - mode: 0440
    - source: salt://ci/ci-sudoers.d
    - require:
      - sls: aur

is_slave:
  grains.present:
    - value: True

crappy-ssh-config:
  file.line:
    - name: /etc/ssh/sshd_config
    - mode: Ensure
    - match: ^KexAlgorithms.*
    - location: end
    - content: KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1
