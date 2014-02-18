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

#if [ ! -d raspberrypi/ ];then
#	mkdir raspberrypi
#fi
#cd raspberrypi/
#if [ -d $PWD/tools ];then
#	echo "[I] Updating compiler..."
#	cd $PWD/tools
#	git pull
#	cd - >/dev/null
#else
#	echo "[I] Cloning compiler..."
#	git clone https://github.com/raspberrypi/tools.git
#
#fi
#cd $ORIG


cd resources/
if [ -d $PWD/busybox ];then
	echo "[I] Updating busybox src..."
	cd $PWD/busybox
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning busybox src..."
	git clone git://busybox.net/busybox.git
fi
cd $ORIG



echo "[I] Compiling busybox..."
CCPREFIX=$ORIG/resources/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabihf-
echo "[I] CC prefix: $CCPREFIX"
NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
echo "[I] CPU Cores: $NUMCORES"


LIBPATH=$ORIG/resources/buildroot/output/staging/
#LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/


cd $PWD/resources/busybox/
sudo make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
cp $ORIG/config/busybox.conf ./.config
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}



cd $ORIG

echo "[I] Making initial directories on target/"
#####
#Extracted from LFS doc
sudo mkdir -p $PWD/target/{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}
sudo mkdir -p $PWD/target/{media/{floppy,cdrom},sbin,srv,var}
sudo install -dv -m 0750 $PWD/target/root
sudo install -dv -m 1777 $PWD/target/tmp $PWD/target/var/tmp
sudo mkdir -p $PWD/target/usr/{,local/}{bin,include,lib,sbin,src}
sudo mkdir -p $PWD/target/usr/{,local/}share/{doc,info,locale,man}
sudo mkdir -p  $PWD/target/usr/{,local/}share/{misc,terminfo,zoneinfo}
sudo mkdir -p $PWD/target/usr/{,local/}share/man/man{1..8}
for dir in $PWD/target/usr $PWD/target/usr/local; do
  sudo ln -sf share/{man,doc,info} $dir
done
sudo mkdir -p $PWD/target/var/{log,mail,spool}
sudo ln -sf $PWD/target/run $PWD/target/var/run
sudo ln -sf $PWD/target/run/lock $PWD/target/var/lock
sudo mkdir -p $PWD/target/var/{opt,cache,lib/{misc,locate},local}

sudo mkdir -p $PWD/target/{sys,dev,proc}

echo "[I] Installing busybox on target/"
cd $PWD/resources/busybox/
sudo make ARCH=arm CROSS_COMPILE=${CCPREFIX} CONFIG_PREFIX=$ORIG/target/ install
echo "[I] setting busybox setuid..."
sudo chown root.root $ORIG/target/bin/busybox
sudo chmod u+s $ORIG/target/bin/busybox

#cp $PWD/resources/busybox/busybox $PWD/target/bin









