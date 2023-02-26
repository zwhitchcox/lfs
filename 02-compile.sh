#!/bin/bash

if [ -z "$LFS" ]; then
   echo "Need to run ./env.sh" > /dev/stderr
   exit 1
fi
set -e

# create directory hierarchy
mkdir -p "$LFS/"{etc,var} "$LFS/usr/"{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sfv "usr/$i" "$LFS/$i"
done

mkdir -pv "$LFS/tools"

chown -v lfs "$LFS"/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64)
    mkdir -p "$LFS/lib64"
    chown -v lfs "$LFS/lib64"
  ;;
esac


cat > /tmp/compile-binutils.sh << "EOF"
cd "$LFS"/sources
tar xvJf binutils*
cd binutils-2.39
mkdir -v build
cd build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror
make
make install
EOF
su -c "bash /tmp/compile-binutils.sh" lfs
