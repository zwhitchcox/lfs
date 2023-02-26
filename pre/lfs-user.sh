#!/bin/bash

set -e
[ -n "$LFS" ] || exit 1

# Check if the "lfs" group and user already exist
if ! getent group lfs >/dev/null; then
    groupadd lfs
fi

if ! id lfs >/dev/null; then
    # Create the "lfs" user with a home directory and the Bash shell
    useradd -m -g lfs -s /bin/bash -k /dev/null lfs
    passwd lfs
fi

# Set up the .bash_profile file for the "lfs" user
cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

# Set up the .bashrc file for the "lfs" user
cat > /home/lfs/.bashrc << "EOF"
# Set default environment variables for the LFS build
export LFS=/mnt/lfs
export LC_ALL=POSIX
export LFS_TGT=$(uname -m)-lfs-linux-gnu
export PATH=/usr/bin:/bin:$LFS/tools/bin
export CONFIG_SITE=$LFS/usr/share/config.site
export PS1='\u:\w\$ '

# Set umask for new files and directories
umask 022

# Set up the environment for the LFS build
set +h
EOF
