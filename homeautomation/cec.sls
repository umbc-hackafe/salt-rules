include:
  - homeautomation.openhalper

libcec-rpi:
  pkg.installed:
    - require_in:
      - service: openhalper
