#!/bin/bash

cd "$LFS"/sources || exit 1
tar xvJf binutils*
cd binutils-2.39 || exit 1
mkdir -v build
cd build || exit 1
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror
make -j6
make install
