ssmtp:
  pkg.installed: []

ledger:
  pkg.installed: []

github.com:
  ssh_known_hosts.present:
    - user: root
    - fingerprint: '16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48'

hackafe-ledger:
  git.latest:
    - name: https://github.com/umbc-hackafe/ledger.git
    - target: /opt/hackafe-ledger
    - require:
      - pkg: git
      - ssh_known_hosts: github.com
  cmd.wait:
    - name: 'git verify-commit HEAD --raw 2>&1 | grep -E "VALIDSIG \b({{ pillar['trusted_signers'].values() | join('|') | upper }})\b"'
    - require:
      - pkg: git
    - watch:
      - git: hackafe-ledger
