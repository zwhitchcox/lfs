#!/bin/bash

set -e

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

# provision file systems
sudo mkfs.fat -F 32 -n boot "$dev_name"p1
sudo mkfs.ext4 -L nixos "$dev_name"p2
