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

echo -e "\n\n PiNAS builder  Copyright (C) 2013  J.A. Nache <ja@nache.net>"
echo " This program comes with ABSOLUTELY NO WARRANTY."
echo " This is free software, and you are welcome to redistribute it"
echo -e " under certain conditions. See LICENSE for more details.\n\n"


if [ -z $1 ];then
	echo -e "\n  Usage: $0 <disk>"
	echo -e "  Example: $0 /dev/sdb\n\n"
	echo -e "WARNING! Make sure you know your"
	echo -e "device name or data will be lost!\n\n"
	exit 1
fi
export SD_DISK=$1
SD_DISK1=$SD_DISK"1"
SD_DISK2=$SD_DISK"2"

function build_sd {

	echo "[I] Erasing disk $SD_DISK..."
	parted -s $SD_DISK mklabel msdos
	echo "[I] Making $SD_DISK 1..."
	parted -s $SD_DISK unit cyl mkpart primary fat32 -- 0 16
	echo "[I] Making $SD_DISK 2..."
	parted -s $SD_DISK unit cyl mkpart primary ext2 -- 16 -2
	echo "[I] Making disk bootable..."
	parted -s $SD_DISK set 1 boot on

	echo "[I] Formating $SD_DISK1..."
	mkfs.vfat $SD_DISK1
	echo "[I] Formating $SD_DISK2..."
	mkfs.ext4 $SD_DISK2

#here we mount parts and copy files

	echo "[I] Mounting SD CARD into $PWD/rootmount..."
	mkdir -p $PWD/rootmount
	MOUNTEDSD=$PWD/rootmount
	mount $SD_DISK1 $MOUNTEDSD

	echo "[I] Copying files into SD CARD..."
	cp -r $PWD/firmware/boot/* $MOUNTEDSD/
	echo "[I] Deleting precompiled kernel from repo..."
	rm -rf $MOUNTEDSD/kernel.img
	rm -rf $MOUNTEDSD/kernel_emergency.img
	echo "root=/dev/mmcblk0p1 initrd=/initrd smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 rootwait" > $MOUNTEDSD/cmdline.txt
	echo "gpu_mem=64" >> $MOUNTEDSD/config.txt
	echo "kernel=kernel.img" >> $MOUNTEDSD/config.txt
	echo "cmdline=cmdline.txt" >> $MOUNTEDSD/config.txt
	echo "initramfs initrd.gz" >> $MOUNTEDSD/config.txt
	cp $PWD/rootfs.sqsh $MOUNTEDSD/
	cp $PWD/raspberrypi/compiled/kernel.img $MOUNTEDSD/
	cp $PWD/initrd.gz $MOUNTEDSD
}

echo "WARNING!! You will lose all data that was on $SD_DISK"
while [ 1 ]; do
        read -p "Continue (yes/n)? " -r
        case "$REPLY" in
          yes ) echo -e "Ok\n"; break;;
          n|N ) echo -e "Aborting...\n"; exit 1;;
          * ) echo -e "Error: Type yes or n";;
        esac
done

build_sd
umount $MOUNTEDSD
