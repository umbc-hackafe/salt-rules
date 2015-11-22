{% if pillar.websites and grains['host'] in pillar.websites %}

nginx:
  pkg.installed: []
  service.running:
    - enable: True

/etc/nginx/ssl:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 700
    - file_mode: 600
    - recurse:
      - user
      - group
      - mode
    - makedirs: True
    - require:
      - pkg: nginx

{% for hostname in pillar.websites[grains['host']] %}
{% set path = ':'.join(['websites', grains['host'], hostname])
{% set host_type = salt['pillar.get'](path + ':type', 'pass') %}
{% set ssl_type = salt['pillar.get'](path + ':ssl', 'star') %}
{% set locations = salt['pillar.get'](path + ':locations', {'/': salt['pillar.get'](path)}) %}
{% set aliases = salt['pillar.git'](path + ':aliases', []) %}
{% set host = salt['pilllar.get'](path + ':host', 'localhost') %}
{% set rewrite = salt['pillar.get'](path + ':rewrite', []) %}

{% if host_type == 'pass' %}
  {% set host_type = 'vhost' %}
  {% set host = hostname %}
{% endif %}

{% if host_type == 'static' %}
{% set static_srctype = salt['pillar.get'](path + ':source:type', 'salt') %}
{% if static_srctype == 'salt' %}
/srv/http/{{ hostname }}:
  file.recurse:
    - source: {{ salt['pillar.get'](path + ':source:location', 'salt://web/static_sites/' + hostname) }}
    - makedirs: True
{% elif static_srctype == 'git' %}
/srv/http/{{ hostname }}:
  file.directory:
    - makedirs: True

/srv/http/{{ hostname }}:
  git.latest:
    - source: {{ salt['pillar.get'](path + ':source:location', 'https://github.com/hackafe/' + hostname) }}
    - require:
      - file: /srv/http/{{ hostname }}
{% endif %}

/etc/nginx/sites-available/{{ hostname }}:
  file.managed:
    - source: {% if host_type == "custom" %}salt://web/custom/{{ hostname }}{% else %}salt://web/{{ host_type }}.jinja{% endif %}
    - template: jinja
    - context:
      hostname: {{ hostname }}
      host_type: {{ host_type }}
      host: {{ host }}
      locations: {{ locations }}
      ssl_type: {{ ssl_type }}
      rewrite: {{ rewrite }}
    - require_in:
      - service: nginx
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/{{ hostname }}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ hostname }}
    - require:
      - file: /etc/nginx/sites-available/{{ hostname }}
    - require_in:
      - service: nginx
    - watch_in:
      - service: nginx
{% endfor %}
