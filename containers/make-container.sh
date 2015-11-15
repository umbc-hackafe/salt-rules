#!/usr/bin/bash
[ -z "$1" ] && echo "Need to select container name" && exit 1;

if [ -d "/var/lib/machines/$1" ]; then
  exit 0;
else
  mkdir /var/lib/machines/$1
  mkdir /data/overlay/$1
  mkdir /data/work/$1
  
  cp /etc/fstab /etc/fstab.bak
  echo "/var/lib/machines/$1		/var/lib/machines/$1	overlay	rw,relatime,lowerdir=/data/baseroot,upperdir=/data/overlay/$1,workdir=/data/work/$1	0 0" >> /etc/fstab

  mount /var/lib/machines/$1

  systemd-machine-id-setup --root=/var/lib/machines/$1
fi
