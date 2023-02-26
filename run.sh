#!/bin/bash

set -e # Exit immediately if a command fails
set -u # Treat unset variables as errors

# Define an array with the script names in order
scripts=(add-sources create-dirs compile)

# Set the start index for the array to 0 if not provided as an argument
start=${1:-0}

# Clean old images and detach loopback devices
for script in "${scripts[@]:start}"; do
   rm -f "build/$script.img"
done
losetup -D
#
# Build new images
for script in "${scripts[@]:start}"; do
   prev_img=${scripts[$(("$start" - 1))]:-disk}
   cp "build/$prev_img.img" "build/$script.img"
   dev_name="$(losetup -fP --show "build/$script.img")"
   mount "${dev_name}p2" "$LFS"
   bash "stages/$script.sh"
   umount -r -q -d "$LFS"
done

# Detach loopback devices
losetup -D
