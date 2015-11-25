{% if pillar.websites and grains['host'] in pillar.websites %}

nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://web/nginx.conf
    - makedirs: True
    - require:
      - pkg: nginx
    - watch_in:
      - service: nginx

{% set letsencrypt_hosts = [h for h,v in salt['pillar.get']('websites:' + grains['host'], {}) if v and 'ssl' in v and v['ssl'] == 'letsencrypt'] %}
{% if letsencrypt_hosts %}
/srv/http/letsencrypt/.well-known/acme-challenge:
  file.directory:
    - makedirs: True

run-letsencrypt:
  cmd.run:
    - name: letsencrypt certonly --agree-dev-preview --agree-tos {% if salt['service.status']('nginx') %}-a webroot -t --webroot-path /srv/http/letsencrypt{% else %}--standalone{% endif %} -m mark25@hackafe.net --rsa-key-size 4096 -d {{ ','.join(letsencrypt_hosts) }}
    - watch_in:
      - service: nginx
    - require_in:
      - service: nginx
    - require:
      - file: /srv/http/letsencrypt/.well-known/acme-challenge
      - sls: letsencrypt
{% endif %}

{% for hostname in pillar.websites[grains['host']] %}
{% set path = ':'.join(['websites', grains['host'], hostname]) %}
{% set host_type = salt['pillar.get'](path + ':type', 'pass') %}
{% set ssl_type = salt['pillar.get'](path + ':ssl', 'star') %}
{% set locations = salt['pillar.get'](path + ':locations', {'/': salt['pillar.get'](path)}) %}
{% set aliases = salt['pillar.get'](path + ':aliases', []) %}
{% set host = salt['pillar.get'](path + ':host', 'localhost') %}
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

download-git-{{ hostname }}:
  git.latest:
    - name: {{ salt['pillar.get'](path + ':source:location', 'https://github.com/umbc-hackafe/' + hostname) }}
    - target: /srv/http/{{ hostname }}
    - require:
      - file: /srv/http/{{ hostname }}
{% endif %}
{% endif %}

{% if ssl_type == 'letsencrypt' %}
/etc/letsencrypt/live/{{ hostname }}/fullchain.pem:
  file.present:
    - prereq:
      - cmd: run-letsencrypt

/etc/nginx/ssl/{{ hostname }}.cert:
  file.symlink:
    - target: /etc/letsencrypt/live/{{ hostname }}/fullchain.pem
    - require:
      - sls: letsencrypt
    - require_in:
      - service: nginx

/etc/nginx/ssl/{{ hostname }}.cert:
  file.symlink:
    - target: /etc/letsencrypt/live/{{ hostname }}/privkey.pem
    - require:
      - sls: letsencrypt
    - require_in:
      - service: nginx
{% endif %}

/etc/nginx/sites-available/{{ hostname }}:
  file.managed:
    - source: {% if host_type == "custom" %}salt://web/custom/{{ hostname }}{% else %}salt://web/{{ host_type }}.jinja{% endif %}
    - makedirs: True
    - template: jinja
    - context:
      hostname: {{ hostname }}
      host_type: {{ host_type }}
      host: {{ host }}
      locations: {{ locations }}
      ssl_type: {{ ssl_type }}
      rewrite: {{ rewrite }}
      aliases: {{ aliases }}
    - require:
      - pkg: nginx
    - require_in:
      - service: nginx
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/{{ hostname }}:
  file.symlink:
    - target: /etc/nginx/sites-available/{{ hostname }}
    - makedirs: True
    - require:
      - file: /etc/nginx/sites-available/{{ hostname }}
      - pkg: nginx
    - require_in:
      - service: nginx
    - watch_in:
      - service: nginx
{% endfor %}
{% endif %}
