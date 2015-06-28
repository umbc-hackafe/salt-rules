jenkins:
  pkg.installed:
    - name: jenkins
  service.running:
    - name: jenkins
    - enable: True
    - require:
      - pkg: jenkins
