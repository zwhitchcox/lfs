#!/bin/bash

if [ -z "$LFS" ]; then
   echo "Need to run ./env.sh" > /dev/stderr
   exit 1
fi

set -e
 ## https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingpartition.html

 # create build directory
 mkdir -p "$BUILD_DIR"

 # create image
 truncate -s 20GiB "$DISK_IMG"

 # create partition table
 parted "$DISK_IMG" \
   mklabel gpt \
   mkpart ESP fat32 1MiB 512MiB \
   mkpart primary 512MiB 100% \
   set 1 esp on

 # mount disk.img
 dev_name="$(losetup -f "$DISK_IMG" -P --show)"

 ##  https://www.linuxfromscratch.org/lfs/view/stable/chapter02/creatingfilesystem.html

 # provision file systems
 mkfs.fat -F 32 -n boot "$dev_name"p1
 mkfs.ext4 -L lfs "$dev_name"p2

 # create mount point for lfs
 mkdir -p "$LFS"

 # mount lfs partition
 mount "$dev_name"p2 "$LFS"

 # create sources dir
 mkdir "$LFS/sources"

 # make  sources dir writable and sticky
 chmod a+wt "$LFS/sources"

 # download all sources
 wget --input-file=wget-list-sysv --continue --directory-prefix="$LFS/sources"

 # check checksums
 pushd "$LFS/sources"
   md5sum -c md5sums
 popd

 if ! groups | grep lfs; then
    groupadd lfs
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    passwd lfs

   cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

   cat > /home/lfs/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
fi
