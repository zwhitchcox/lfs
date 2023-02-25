#!/bin/bash

if [ -z "$LFS" ]; then
   echo "Need to run ./env.sh" > /dev/stderr
   exit 1
fi

umount -r -q -d "$LFS"

# detach loop back device
for dev in $(losetup -j "$DISK_IMG" -O NAME| tail -n +2); do
    losetup -d "$(echo "$dev" | awk '{print $1}')"
done

# remove disk image and mount points
rm -rf build mnt
