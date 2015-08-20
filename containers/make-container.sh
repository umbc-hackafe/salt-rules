#!/usr/bin/bash
[ -z "$1" ] && echo "Need to select container name" && exit 1;

if [ -d "/data/$1" ]; then
  exit 0;
else
  mkdir /data/$1
  mkdir /data/overlay/$1
  mkdir /data/work/$1
  
  cp /etc/fstab /etc/fstab.bak
  echo "/data/$1		/data/$1	overlay	rw,relatime,lowerdir=/data/baseroot,upperdir=/data/overlay/$1,workdir=/data/work/$1	0 0" >> /etc/fstab

  mount /data/$1

  systemd-machine-id-setup --root=/data/$1
  
  ln -s /data/$1 /var/lib/container/$1
fi
