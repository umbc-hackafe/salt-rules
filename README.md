# Salt Configuration

This repository contains Salt configuration and rules for Hackafé. If you don't know exactly what
that is, please don't modify this.

The Salt master reads this repository from `/var/git/saltmaster`, which is itself can be pushed to
from developer copies. This is done using Salt's `fileserver_backend: git` feature.

# Provisioning

The idea motivating most of this project is to make reconfiguring and configuring from scratch
systems. For example, we find ourselves frequently wiping and re-provisioning Raspberry Pi's and
other systems. In particular, we can standardize access, passwords, keys, and services such as Salt,
and home automation helpers.

## Management

It can be handy to include 'meta' rules which ensure that services such as `salt-minion` are
properly enabled and running. This is provided by the `managed` formula.

## Users, Passwords, and Keys

Users are created and managed by the `users` formula.

Passwords do not yet have a solution.

Keys are dropped into place via the fileserver and are provided also by the `users` formula.
