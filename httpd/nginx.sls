httpd:
  pkg.installed:
    - name: nginx
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: httpd
  group.present:
    - name: http
    - system: True
    {% if pillar['admins'] %}
    - members:
      {% for admin in pillar['admins'] %}
      - {{admin}}
      {% endfor %}
    {% endif %}
