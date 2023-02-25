#!/bin/bash

# detach loop back device
sudo losetup -D ./build/disk.img

# remove disk image and mount points
rm -rf build
