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

ORIG=$PWD

cd resources/
if [ -d $PWD/buildroot ];then
	echo "[I] Updating uclibc buildroot src..."
	cd $ORIG/resources/buildroot
	git checkout 2013.08.x
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning uclibc buildroot src..."
	git clone git://git.buildroot.net/buildroot
	cd $ORIG/resources/buildroot
	git checkout 2013.08.x
fi
cd $ORIG/resources/buildroot

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)

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

echo "[I] Cleaning buildroot..."
make clean || echo "Nothing to clean"
make distclean || echo "Nothing to clean"


echo "[I] Configuring..."
cp $ORIG/config/uclibc.conf $ORIG/resources/buildroot/package/uclibc/uClibc-snapshot.config.pinas
cp $ORIG/config/buildroot.conf ./.config

make olddefconfig

echo "[I] Building..."
make toolchain








