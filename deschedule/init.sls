deschedule:
  git.latest:
    - name: https://github.com/alexander-bauer/deschedule
    - target: /opt/deschedule
    - branch: stable
  cmd.wait:
    - name: make requirements
    - cwd: /opt/deschedule
    - require:
      - git: deschedule
    - watch:
      - git: deschedule

deschedule-dirs:
  file.directory:
    - name: /var/deschedule

deschedule-bin:
  file.symlink:
    - name: /usr/bin/deschedule
    - target: /opt/deschedule/run.py
    - require:
      - git: deschedule

deschedule-service:
  file.symlink:
    - name: /usr/lib/systemd/system/deschedule.service
    - target: /opt/deschedule/packaging/deschedule.service
    - require:
      - git: deschedule
  service.running:
    - name: deschedule
    - enable: true
    - require:
      - git: deschedule
      - file: deschedule-dirs
      - file: deschedule-bin
      - file: deschedule-service
      - pkg: deschedule-pkgs

deschedule-pkgs:
  pkg.installed:
    - pkgs: [ 'python', 'python-pip' ]
