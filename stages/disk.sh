#!/bin/bash

set -eux

# create build directory and image
mkdir -p "$BUILD_DIR"
truncate -s 20GiB "$DISK_IMG"

# partition image
parted "$DISK_IMG" \
  mklabel gpt \
  mkpart ESP fat32 1MiB 512MiB \
  mkpart primary 512MiB 100% \
  set 1 esp on

# create loopback devices
dev_name="$(losetup -fP --show "$DISK_IMG")"

# create partitions
mkfs.fat -F 32 -n boot "$dev_name"p1
mkfs.ext4 -L lfs "$dev_name"p2
mkdir -p "$LFS"
