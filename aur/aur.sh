#!/bin/bash
if [ ! -z $1 ]
then
    PKGNAME=$1
fi

curl "https://aur.archlinux.org/cgit/aur.git/snapshot/$PKGNAME.tar.gz" | tar xz
cd $PKGNAME
makepkg --install --clean
