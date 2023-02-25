#!/bin/bash

# create image
truncate -s 20GiB disk.img

# create partition table
parted disk.img \
  mklabel gpt \
  mkpart primary 512MB 100%
