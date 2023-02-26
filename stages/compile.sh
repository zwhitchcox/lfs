#!/bin/bash

set -e
[ -n "$LFS" ] || exit 1

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
