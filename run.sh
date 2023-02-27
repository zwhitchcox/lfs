#!/bin/bash

set -euxo pipefail

# Define an array with the script names in order
scripts=(disk add-sources create-dirs)
libs=(binutils gcc linux)
all=("${scripts[@]}" "${libs[@]}")

# Set the start index for the array to 0 if not provided as an argument
start=${1:-0}

# Clean old images 
for script in "${all[@]:start}"; do
   rm -f "build/$script.img"
done

# unmount lfs and detach loopback devices
clean() {
   umount -r -q -d "$LFS"
   losetup -D
}

clean

# Set the previous image name based on the start index
if [ "$start" -eq 0 ]; then
   prev_img=disk
   bash stages/disk.sh
   start=1
else
   prev_img=${all[start-1]}
fi

clone_img() {
   src="$1"
   dst="$2"
   clean
   mkdir -p "$LFS"
   cp -f "build/$src.img" "build/$dst.img"
   dev_name="$(losetup -fP --show "build/$dst.img")"
   sleep .1
   mount "${dev_name}p2" "$LFS"
}

# Build new images
for script in "${scripts[@]:start}"; do
   clone_img "$prev_img" "$script"
   bash "stages/$script.sh"
   echo "finished $script"
   prev_img=$script
done

lib_start=$((start-${#scripts[@]}))
[[ "$lib_start" -le 0 ]] && lib_start=0

# compile libraries
for lib in "${libs[@]:lib_start}"; do
   clone_img "$prev_img" "$lib"
   bash stages/compile.sh "$lib"
   prev_img="$lib"
done

# Detach loopback devices
clean
