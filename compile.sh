#!/bin/bash

if [ -z "$LFS" ]; then
   echo "Need to run ./env.sh" > /dev/stderr
   exit 1
fi
set -e

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


lfs_script() {
   cp  ./compile-scripts/"$1".sh /tmp/"$1".sh
   cp  ./env.sh /tmp/env.sh
   cat >> /tmp/env.sh  << EOF
cd $LFS/sources
untar_source $1
cd $1
EOF
   su -c "source /tmp/env.sh && bash /tmp/$1.sh" lfs
}

lfs_script binutils
lfs_script gcc
lfs_script linux
