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
if [ -d $PWD/glibc ];then
	echo "[I] Updating glibc src..."
	cd $PWD/glibc
	#svn update
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning glibc src..."
	git clone git://sourceware.org/git/glibc.git
	#svn co svn://svn.eglibc.org/branches/eglibc-2_18 eglibc
fi

cd $ORIG
[ -d $ORIG/resources/glibc_build ] || mkdir $ORIG/resources/glibc_build
cd $ORIG/resources/glibc/


NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/

#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}/usr/lib/ LDFLAGS="-L${LIBPATH}/usr/lib/"

#echo "[I] Compiling glibc..."
#cd resources/cpython

echo "[I] Cleaning libc..."
make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"

echo "[I] Making headers..."
[ -d $ORIG/target_linux_headers ] || mkdir $ORIG/target_linux_headers
cd $ORIG/raspberrypi/linux/
#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} make headers_install INSTALL_HDR_PATH=$ORIG/target_linux_headers

echo "[I] Cleaning glibc_build..."
cd $ORIG/resources/glibc_build
make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"
#echo "[I] Configuring src before build..."

echo "[I] Configuring..."
ARCH=arm CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" CPPFLAGS="${CPPFLAGS} -U_FORTIFY_SOURCE" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} $ORIG/resources/glibc/configure --prefix=$ORIG/target/ --enable-shared --disable-profile --disable-versioning --disable-obsolete-rpc --disable-systemtap --disable-build-nscd --disable-nscd --disable-pt_chown --without-bugurl --without-bd --without-selinux --build=i686-pc-linux-gnu --host=arm-linux-gnueabi --without-cvs --enable-kernel=2.6.32 --enable-obsolete-rpc --without-tls --with-headers=$ORIG/target_linux_headers/include/



make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} install


[ -d $ORIG/target ] || mkdir $ORIG/target


#make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} install

#CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
#echo "[I] CC prefix: $CCPREFIX"
#NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
#echo "[I] CPU Cores: $NUMCORES"

#cd $PWD/resources/busybox/
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
#cp $ORIG/config/busybox.conf ./.config
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}
#cd $ORIG








