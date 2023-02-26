#!/bin/bash

set -e
[ -n "$LFS" ] || exit 1

# create directory hierarchy
mkdir -p "$LFS/"{etc,var} "$LFS/usr/"{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sfv "usr/$i" "$LFS/$i"
done

mkdir -pv "$LFS/tools"

chown -v lfs "$LFS"/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64)
    mkdir -p "$LFS/lib64"
    chown -v lfs "$LFS/lib64"
  ;;
esac

