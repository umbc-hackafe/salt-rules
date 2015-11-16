{% for name, fingerprint in pillar['trusted_signers'].items() %}
{{name}}_gpg:
  module.run:
    - name: gpg.receive_keys
    - keys: {{ fingerprint | replace(' ', '') }}
    - unless:
      - gpg --list-keys {{ fingerprint | replace(' ', '')}}
{% endfor %}
