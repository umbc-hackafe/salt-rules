{% for name, fingerprint in pillar['trusted_signers'].items() %}
{{name}}_gpg:
  module.wait:
    - name: gpg.receive_keys
    - keys: {{ fingerprint | replace(' ', '') }}
    - unless:
      - gpg --list-keys {{ fingerprint | replace(' ', '')}}
{% endfor %}
