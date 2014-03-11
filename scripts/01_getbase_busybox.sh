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

PNAME="busybox"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

down_busybox

cd $RESOURCESDIR/busybox/
sudo make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
cp $ORIG/config/busybox.conf ./.config

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}

cd $ORIG

echo_info "Making initial directories on $TARGETDIR"
#####
#Extracted from LFS doc
sudo mkdir -p $TARGETDIR/{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}
sudo mkdir -p $TARGETDIR/{media/{floppy,cdrom},sbin,srv,var}
sudo install -dv -m 0750 $TARGETDIR/root
sudo install -dv -m 1777 $TARGETDIR/tmp $TARGETDIR/var/tmp
sudo mkdir -p $TARGETDIR/usr/{,local/}{bin,include,lib,sbin,src}
sudo mkdir -p $TARGETDIR/usr/{,local/}share/{doc,info,locale,man}
sudo mkdir -p  $TARGETDIR/usr/{,local/}share/{misc,terminfo,zoneinfo}
sudo mkdir -p $TARGETDIR/usr/{,local/}share/man/man{1..8}
for dir in $TARGETDIR/usr $TARGETDIR/usr/local; do
  sudo ln -sf share/{man,doc,info} $dir
done
sudo mkdir -p $TARGETDIR/var/{log,mail,spool}
sudo ln -sf $TARGETDIR/run $TARGETDIR/var/run
sudo ln -sf $TARGETDIR/run/lock $TARGETDIR/var/lock
sudo mkdir -p $TARGETDIR/var/{opt,cache,lib/{misc,locate},local}

sudo mkdir -p $TARGETDIR/{sys,dev,proc}

echo_info "Installing busybox on $TARGETDIR"
cd $RESOURCESDIR/busybox/
sudo make ARCH=arm CROSS_COMPILE=${CCPREFIX} CONFIG_PREFIX=$TARGETDIR/ install
echo_info "Setting busybox setuid..."
sudo chown root.root $TARGETDIR/bin/busybox
sudo chmod u+s $TARGETDIR/bin/busybox

