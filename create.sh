#!/bin/bash

set -e
set -x
## https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingpartition.html

# create build directory
mkdir -p build

# create image
truncate -s 20GiB build/disk.img

# create partition table
parted build/disk.img \
  mklabel gpt \
  mkpart ESP fat32 1MiB 512MiB \
  mkpart primary 512MiB 100% \
  set 1 esp on

# mount disk.img
dev_name="$(sudo losetup -f build/disk.img -P --show)"

##  https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingfilesystem.html

# provision file systems
sudo mkfs.fat -F 32 -n boot "$dev_name"p1
sudo mkfs.ext4 -L lfs "$dev_name"p2

# create mount point for lfs
export LFS=./mnt/lfs
mkdir -p $LFS

# mount lfs partition
sudo mount "$dev_name"p2 "$LFS"
