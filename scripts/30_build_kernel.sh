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
PNAME="linux kernel"

down_linux

CCPREFIX=$ORIG/resources/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabihf-

cd $LINUX_DIR
echo_info "Cleaning..."
make mrproper
echo_info "Using config arch/arm/configs/bcmrpi_defconfig"
cp arch/arm/configs/bcmrpi_defconfig ./.config
echo_info "Setting squashfs compiled into kernel..."
sed -i -e "s/^CONFIG_SQUASHFS=.*/CONFIG_SQUASHFS=y/" .config

EXTVER=-PiNAS-`date +%Y%m%d%H%M`
echo_info "Seting extraversion $EXTVER"
sed -i -e "s/^EXTRAVERSION =.*/EXTRAVERSION = $EXTVER/" Makefile

echo_info "Making config..."
make ARCH=arm CROSS_COMPILE=${CCPREFIX} olddefconfig
#diff .config arch/arm/configs/bcmrpi_defconfig

echo_info "Compiling Kernel... make coffee."
NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}

echo_info "Compiling Modules..."
make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} modules

mkdir -p ../compiled

echo_info "Building modules dir..."
MODULES_TARGET_DIR=$TARGETDIR
sudo make ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TARGET_DIR} modules_install

echo_info "Copying Kernel image..."
cp arch/arm/boot/zImage ../compiled/kernel.img

cd $ORIG
