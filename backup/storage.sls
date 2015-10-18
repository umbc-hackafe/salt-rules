bacula:
  pkg.installed:
    - pkgs:
      - mtx-svn
      - mt-st-git
      - bacula-sd

sg:
  kmod.present:
    - persist: True
    - require_in: bacula
