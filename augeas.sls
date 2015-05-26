{% set augeas_pkgname = salt['grains.filter_by']({
  'arch': 'python2-augeas'
  }, grain='os_family', default='arch')
%}

augeas:
  pkg.installed:
    - name: {{ augeas_pkgname }}