{% if pillar.containerhosts and grains['host'] in pillar.containerhosts %}
{% for container in pillar.containerhosts[grains['host']] %}
{{container}}:
  file.symlink:
    - name: /var/lib/container/{{container}}
    - target: /data/{{container}}
  service.enabled:
    - name: systemd-nspawn@{{container}}.service
  mount.mounted:
    - name: /data/{{container}}
    - device: /data/{{container}}
    - fstype: overlay
    - opts: rw,relatime,lowerdir=/data/baseroot,upperdir=/data/overlay/{{container}},workdir=/data/work/{{container}}
    - persist: True
    - mount: False # do not mount immediately; just modify the fstab
    - mkmnt: True

/data/{{container}}:
  file.directory: []
/data/overlay/{{container}}:
  file.directory: []
/data/work/{{container}}:
  file.directory: []

{% endfor %}
{% endif %}
