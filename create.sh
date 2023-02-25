#!/bin/bash

set -e
## https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingpartition.html

# create build directory
mkdir -p "$BUILD_DIR"

# create image
truncate -s 20GiB "$DISK_IMG"

# create partition table
parted "$DISK_IMG" \
  mklabel gpt \
  mkpart ESP fat32 1MiB 512MiB \
  mkpart primary 512MiB 100% \
  set 1 esp on

# mount disk.img
dev_name="$(sudo losetup -f "$DISK_IMG" -P --show)"

##  https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingfilesystem.html

# provision file systems
sudo mkfs.fat -F 32 -n boot "$dev_name"p1
sudo mkfs.ext4 -L lfs "$dev_name"p2

# create mount point for lfs
mkdir -p $LFS

# mount lfs partition
sudo mount "$dev_name"p2 "$LFS"
