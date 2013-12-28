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

echo -e "\n\n PiNAS builder  Copyright (C) 2013  J.A. Nache <ja@nache.net>"
echo " This program comes with ABSOLUTELY NO WARRANTY."
echo " This is free software, and you are welcome to redistribute it"
echo -e " under certain conditions. See LICENSE for more details.\n\n"


if [ -z $1 ];then
	echo -e "\n  Usage: $0 <disk>\n\n"
	exit 1
fi
SD_DISK=$1
SD_DISK1="$(SD_DISK)1"
SD_DISK2="$(SD_DISK)2"

function msg_and_quit {
	echo "**************************************"
	echo "**************************************"
	echo "*************** ERROR ****************"
	echo "**************************************"
	echo "**************************************"
	echo "[E] An ERROR ocurred making SD"
        exit 1
}

function build_sd {

if [ ! -d $PWD/raspberrypi ];then
	mkdir $PWD/raspberrypi
fi

if [ -d $PWD/raspberrypi/boot ];then
	echo "[I] Updating boot files..."
	cd $PWD/raspberrypi/boot
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning boot files from repo..."
	cd $PWD/raspberrypi
	git clone https://github.com/raspberrypi/firmware/tree/next/boot
	cd - >/dev/null
fi

echo "[I] Deleting precompiled kernel from repo..."
rm -rf $PWD/raspberrypi/boot/kernel.img
rm -rf $PWD/raspberrypi/boot/kernel_emergency.img

	echo "[I] Erasing disk $SD_DISK..."
	parted -s $SD_DISK mklabel msdos
	echo "[I] Making $SD_DISK 1..."
	parted -s $SD_DISK unit cyl mkpart primary fat32 -- 0 16
	echo "[I] Making $SD_DISK 2..."
	parted -s $SD_DISK unit cyl mkpart primary ext2 -- 16 -2
	echo "[I] Making disk bootable..."
	parted -s $SD_DISK set 1 boot on


#here we mount parts and copy files

	echo "[I] Mounting SD CARD into $PWD/rootmount..."
	if [ ! -d $PWD/rootmount ];then
		mkdir rootmount
	fi

	MOUNTEDSD=$PWD/rootmount
	mount $SD_DISK1 $PWD/rootmount

	echo "[I] Copying files into SD CARD..."
	cp -r $PWD/raspberrypi/boot/* $MOUNTEDSD/
	echo "boot=/dev/mmcblk0p1 disk=/dev/mmcblk0p2" > $MOUNTEDSD/cmdline.txt
	echo "initramfs initrd.gz" >> $MOUNTEDSD/config.txt
	cp $PWD/rootfs.sqsh $MOUNTEDSD/
	cp $PWD/raspberrypi/compiled/kernel.img $MOUNTEDSD/
	cp $PWD/initrd.gz $MOUNTEDSD
}

build_sd || msg_and_quit
