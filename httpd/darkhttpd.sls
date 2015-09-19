httpd:
  pkg.installed:
    - name: darkhttpd
  service.running:
    - name: darkhttpd
    - enable: True
    - require:
      - pkg: darkhttpd
  group.present:
    - name: http
    - system: True
    - members:
      - http
      {% if pillar['admins'] %}
      {% for admin in pillar['admins'] %}
      - {{admin}}
      {% endfor %}
      {% endif %}
  file.managed:
    - name: /etc/conf.d/mimetypes
  file.managed:
    - name: /srv/http
    - user: root
    - group: http
    - dir_mode: 775
    - file_mode: 664
    - recurse:
      - user
      - group
      - mode
