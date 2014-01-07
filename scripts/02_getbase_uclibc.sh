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
if [ -d $PWD/uclibc ];then
	echo "[I] Updating uclibc src..."
	cd $PWD/uclibc
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning uclibc src..."
	git clone git://uclibc.org/uClibc.git uclibc
fi
cd uclibc

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/
#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}/usr/lib/ LDFLAGS="-L${LIBPATH}/usr/lib/"

echo "[I] Compiling uclibc..."

echo "[I] Cleaning uclibc..."
make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"

echo "[I] Configuring..."
cp $ORIG/config/uclibc.conf ./.config
LINUXPATH=$ORIG/target_linux_headers/include/
sed -i -e "s+^KERNEL_HEADERS=.*+KERNEL_HEADERS=\"$LINUXPATH\"+" .config

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} oldconfig

echo "[I] Building..."
make CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}

echo "[I] Installing..."
[ -d $ORIG/target ] || mkdir $ORIG/target
make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} PREFIX=$ORIG/target install









