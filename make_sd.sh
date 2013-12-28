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

function msg_and_quit {
	echo "**************************************"
	echo "**************************************"
	echo "*************** ERROR ****************"
	echo "**************************************"
	echo "**************************************"
	echo "[E] An ERROR ocurred making SD"
        exit 1
}

function part_sd {
	parted -s "$DISK" mklabel msdos
	parted -s "$DISK" unit cyl mkpart primary fat32 -- 0 16
	parted -s "$DISK" unit cyl mkpart primary ext2 -- 16 -2
	parted -s "$DISK" set 1 boot on


#here we mount parts and copy files

	MOUNTSD=$PWD/rootmount

	echo "boot=/dev/mmcblk0p1 disk=/dev/mmcblk0p2" > $MOUNTSD/cmdline.txt

	echo "initramfs initrd.gz" >> $MOUNTSD/cmdline.txt


}

part_sd || msg_and_quit
