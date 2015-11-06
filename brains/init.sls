clisp:
  pkg.installed

python3:
  pkg.installed

hackafe_admins:
  grains.present:
    - value: True
