#!/bin/bash

set -eux

# create directories
mkdir -p "$LFS/"{etc,var,tools} "$LFS/usr/"{bin,lib,sbin}

# Create symbolic links for bin, lib and sbin directories
for i in bin lib sbin; do
  ln -sfv "usr/$i" "$LFS/$i"
done


# Set ownership of directories
chown -v lfs "$LFS"/{usr{,/*},lib,var,etc,bin,sbin,tools}

# Create lib64 directory for x86_64 architecture
case $(uname -m) in
  x86_64)
    mkdir -p "$LFS/lib64"
    chown -v lfs "$LFS/lib64"
  ;;
esac

