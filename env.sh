#!/bin/bash

export LFS=/mnt/lfs
export BUILD_DIR=./build
export DISK_IMG="$BUILD_DIR"/disk.img
export MAKEFLAGS="-j6"

untar_source() {
   tar_file="$(ls ./"$1"*.tar*)"
   tar xf "$tar_file"
   tld="$(tar -t -f "$tar_file" | head -n 1)"
   mv "$tld" "$1"
}
