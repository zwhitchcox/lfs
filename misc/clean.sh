#!/bin/bash

if [ -z "$LFS" ]; then
   echo "Need to run ./env.sh" > /dev/stderr
   exit 1
fi

umount -r -q -d "$LFS"

losetup -D

# remove disk image and mount points
rm -rf build/disk.img
