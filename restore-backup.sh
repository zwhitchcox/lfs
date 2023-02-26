#!/bin/bash

cp -f build/disk.img.bk build/disk.img

 # mount disk.img
 dev_name="$(losetup -f "$DISK_IMG" -P --show)"

 # create mount point for lfs
 mkdir -p "$LFS"

 # mount lfs partition
 mount "$dev_name"p2 "$LFS"
