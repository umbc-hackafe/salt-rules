bacula:
  pkg.installed:
    - pkgs:
      - mtx-svn
      - mt-st-git
      - bacula-bat
      - bacula-console
      - bacula-dir-postgresql
      - bacula-sd

sg:
  kmod.present:
    - persist: True
    - require_in: bacula
