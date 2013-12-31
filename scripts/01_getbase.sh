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
if [ -d $PWD/samba ];then
	echo "[I] Updating samba src..."
	cd $PWD/samba
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning samba src..."
	git clone git://git.samba.org/samba.git
fi
cd $ORIG

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/
#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH} LDFLAGS="-L${LIBPATH}"

echo "[I] Compiling samba..."
cd resources/samba

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH} LDFLAGS="-L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} clean

ARCH=arm CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH} LDFLAGS="-L${LIBPATH}" CROSS_COMPILE=${CCPREFIX} ./configure --without-gettext --without-winbind --without-ads --without-ldap --disable-cups --disable-iprint --without-pam --without-pam_smbpass --without-quotas --without-sendfile-support --without-utmp --disable-avahi --with-iconv --without-acl-support --without-dnsupdate --without-automount --with-aio-support --without-dmapi --without-fam --without-profiling-data --without-cluster-support --without-regedit --disable-glusterfs --without-ad-dc  --without-pie --nopyc --nopyo --fatal-errors --cross-compile --cross-execute='qemu-arm-static -L ${LIBPATH}' --destdir=$ORIG/target/

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH} LDFLAGS="-L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX}

#CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
#echo "[I] CC prefix: $CCPREFIX"
#NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
#echo "[I] CPU Cores: $NUMCORES"

#cd $PWD/resources/busybox/
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
#cp $ORIG/config/busybox.conf ./.config
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}
#cd $ORIG








