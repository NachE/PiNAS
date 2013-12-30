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

if [ -d $PWD/linux ];then
	echo "[I] Updating linux kernel source ..."
	cd $PWD/linux
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning linux kernel source..."
	git clone https://github.com/raspberrypi/linux.git
fi


CCPREFIX=$PWD/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
cd linux/
echo "[I] Cleaning..."
make mrproper
echo "[I] Using config arch/arm/configs/bcmrpi_defconfig"
cp arch/arm/configs/bcmrpi_defconfig ./.config
echo "[I] Setting squashfs compiled into kernel..."
sed -i -e "s/^CONFIG_SQUASHFS=.*/CONFIG_SQUASHFS=y/" .config


EXTVER=-PiNAS-`date +%Y%m%d%H%M`
echo "[I] Seting extraversion $EXTVER"
sed -i -e "s/^EXTRAVERSION =.*/EXTRAVERSION = $EXTVER/" Makefile

echo "[I] Making config..."
make ARCH=arm CROSS_COMPILE=${CCPREFIX} olddefconfig
#diff .config arch/arm/configs/bcmrpi_defconfig

echo "[I] Compiling Kernel... make coffee."
NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}

echo "[I] Compiling Modules..."
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} modules

if [ ! -d ../compiled ];then
	mkdir ../compiled
fi

echo "[I] Building modules dir..."
MODULES_TARGET_DIR=../../target/
make ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TARGET_DIR} modules_install

echo "[I] Copying Kernel image..."
cp arch/arm/boot/zImage ../compiled/kernel.img

cd $ORIG
