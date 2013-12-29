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


if [ ! -d raspberrypi/ ];then
	mkdir raspberrypi
fi
cd raspberrypi/
if [ -d $PWD/tools ];then
	echo "[I] Updating compiler..."
	cd $PWD/tools
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning compiler..."
	git clone https://github.com/raspberrypi/tools.git

fi
cd $ORIG

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
CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
echo "[I] CC prefix: $CCPREFIX"
NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
echo "[I] CPU Cores: $NUMCORES"

cd $PWD/resources/busybox/
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
cp $ORIG/config/busybox.conf ./.config
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}

cd $ORIG

echo "[I] Erasing target/"
rm -rf $ORIG/target
echo "[I] Making initial directories on target/"
#####
#Extracted from LFS doc
mkdir -pv $PWD/target/{bin,boot,etc/{opt,sysconfig},home,lib,mnt,opt,run}
mkdir -pv $PWD/target/{media/{floppy,cdrom},sbin,srv,var}
install -dv -m 0750 $PWD/target/root
install -dv -m 1777 $PWD/target/tmp $PWD/target/var/tmp
mkdir -pv $PWD/target/usr/{,local/}{bin,include,lib,sbin,src}
mkdir -pv $PWD/target/usr/{,local/}share/{doc,info,locale,man}
mkdir -v  $PWD/target/usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv $PWD/target/usr/{,local/}share/man/man{1..8}
for dir in $PWD/target/usr $PWD/target/usr/local; do
  ln -sv share/{man,doc,info} $dir
done
mkdir -v $PWD/target/var/{log,mail,spool}
ln -sv $PWD/target/run $PWD/target/var/run
ln -sv $PWD/target/run/lock $PWD/target/var/lock
mkdir -pv $PWD/target/var/{opt,cache,lib/{misc,locate},local}

mkdir -pv $PWD/target/{sys,dev,proc}

echo "[I] Installing busybox on target/"
cd $PWD/resources/busybox/
make ARCH=arm CROSS_COMPILE=${CCPREFIX} CONFIG_PREFIX=$ORIG/target/ install
chown root.root $ORIG/target/bin/busybox
chmod u+s $ORIG/target/bin/busybox

#cp $PWD/resources/busybox/busybox $PWD/target/bin









