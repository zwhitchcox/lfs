#!/bin/bash

set -eux

cp  ./compile-scripts/"$1".sh /tmp/"$1".sh
cp  ./misc/env.sh /tmp/env.sh
cat >> /tmp/env.sh  << EOF
cd $LFS/sources
untar_source $1
cd $1
EOF
su -c "source \$HOME/.bashrc && source /tmp/env.sh && bash /tmp/$1.sh" lfs
