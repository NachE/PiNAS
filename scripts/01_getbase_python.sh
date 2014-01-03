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
if [ -d $PWD/cpython ];then
	echo "[I] Updating python src..."
	cd $PWD/cpython
	hg pull
	cd - >/dev/null
else
	echo "[I] Cloning python src..."
	hg clone http://hg.python.org/cpython
	echo "[I] Switching to 2.7 branch..."
	hg update -C 2.7
fi

echo "[I] Making CONFIG_SITE file..."
echo -e "ac_cv_file__dev_ptmx=no\nac_cv_file__dev_ptc=no\n" > $ORIG/resources/cpython/configsite.pinas
cd $ORIG

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/

#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}/usr/lib/ LDFLAGS="-L${LIBPATH}/usr/lib/"

echo "[I] Compiling python..."
cd resources/cpython

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"

echo "[I] Configuring src before build..."
ARCH=arm CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/" CROSS_COMPILE=${CCPREFIX} CONFIG_SITE=configsite.pinas QEMU_LD_PREFIX=${LIBPATH} ./configure --prefix=$ORIG/target_python  --host=arm-linux --build=i686-pc-linux-gnu --enable-shared --disable-ipv6 --without-pydebug 

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}

[ -d $ORIG/target_python ] || mkdir $ORIG/target_python

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} install

#CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
#echo "[I] CC prefix: $CCPREFIX"
#NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
#echo "[I] CPU Cores: $NUMCORES"

#cd $PWD/resources/busybox/
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
#cp $ORIG/config/busybox.conf ./.config
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}
#cd $ORIG








