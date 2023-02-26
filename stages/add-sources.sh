#!/bin/bash

set -e
[ -n "$LFS" ] || exit 1

# create sources dir
mkdir "$LFS/sources"

# make  sources dir writable and sticky
chmod a+wt "$LFS/sources"

# download all sources
wget --input-file=./misc/wget-list-sysv --continue --directory-prefix="$LFS/sources"

# check checksums
pushd "$LFS/sources"
  md5sum -c md5sums
popd
