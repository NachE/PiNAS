#!/bin/bash
##############################################################################
#
#    PiNAS Linux Distribution builder
#    Copyright (C) 2013 Juan Antonio Nache <ja@nache.net>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
############################################################################

set -e

ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_functions/general.sh
PNAME="qemu"

# $1 repository, $2 branch, $3 directory
echo_info "qemu"
git_down_upd git://git.qemu-project.org/qemu.git stable-1.6 $ORIG/resources/qemu

cd $ORIG/resources/qemu

unset CC
unset CPP
unset CXX
unset LD
unset NM
unset AR
unset RANLIB
unset ARCH
unset CROSS_COMPILE
unset QEMU_LD_PREFIX
unset LD_LIBRARY_PATH
unset LDFLAGS

echo_info "$PNAME Cleaning qemu..."
make clean || echo "Nothing to clean"

echo_info "$PNAME Configuring..."
./configure --disable-kvm --target-list="arm-softmmu arm-linux-user" --disable-sdl --prefix=$ORIG/host/ 

echo_info "$PNAME Building..."
make -j $NUMCORES

echo_info "$PNAME Installing..."
mkdir -p $ORIG/host
make -j $NUMCORES install

echo_info "$PNAME setting up binfmt. ARM will be exec by $ORIG"
sudo $ORIG/scripts_utils/enable_arm_binfmt.sh $ORIG/host/bin/qemu-arm
