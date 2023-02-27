#!/bin/bash

set -eux

# create sources dir
mkdir "$LFS/sources"

# make  sources dir writable and sticky
chmod a+wt "$LFS/sources"

set +e
# download all sources
wget --input-file=./misc/wget-list-sysv --continue --directory-prefix="$LFS/sources"
