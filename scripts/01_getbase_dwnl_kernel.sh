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
mkdir -p raspberrypi
cd raspberrypi
if [ -d $PWD/linux ];then
	echo "[I] Updating linux kernel source ..."
	cd $PWD/linux
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning linux kernel source..."
	git clone https://github.com/raspberrypi/linux.git
fi

echo "[I] Making headers..."
[ -d $ORIG/target_linux_headers ] || mkdir $ORIG/target_linux_headers
cd $ORIG/raspberrypi/linux/
CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} make headers_install INSTALL_HDR_PATH=$ORIG/target_linux_headers


