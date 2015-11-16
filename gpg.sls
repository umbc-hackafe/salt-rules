gnupg:
  pkg.installed: []

{% for name, fingerprint in pillar['trusted_signers'].items() %}
{% set fingerprint_stripped = fingerprint | replace(' ', '') %}
{{name}}_gpg:
  cmd.run:
    - name: gpg --recv-key {{ fingerprint_stripped }}
    - keys: {{ fingerprint_stripped }}
    - unless:
      - gpg --list-keys {{ fingerprint_stripped }}
    - require:
      - pkg: gnupg
{% endfor %}
