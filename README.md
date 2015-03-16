# Salt Configuration

This repository contains Salt configuration and rules for Hackafé. If you don't know exactly what
that is, please don't modify this.

The Salt master reads this repository from `/var/git/saltmaster`, which is itself can be pushed to
from developer copies. This is done using Salt's `fileserver_backend: git` feature.
