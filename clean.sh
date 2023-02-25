#!/bin/bash
#
export LFS=./mnt/lfs

sudo umount -r -q -d "$LFS"

# detach loop back device
for dev in $(losetup -j ./build/disk.img -O NAME| tail -n +2); do
    sudo losetup -d "$(echo "$dev" | awk '{print $1}')"
done

# remove disk image and mount points
rm -rf build mnt
