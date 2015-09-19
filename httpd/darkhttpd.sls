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
    {% if pillar['admins'] %}
    - members:
      {% for admin in pillar['admins'] %}
      - {{admin}}
      {% endfor %}
    {% endif %}
  file.managed:
    - name: /etc/conf.d/mimetypes
