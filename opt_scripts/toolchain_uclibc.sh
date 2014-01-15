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
if [ -d $PWD/buildroot ];then
	echo "[I] Updating uclibc buildroot src..."
	cd $PWD/buildroot
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning uclibc buildroot src..."
	git clone git://git.buildroot.net/buildroot
fi
cd buildroot

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)

unset CC
unset CXX
unset LD
unset NM
unset AR
unset RANLIB
unset ARCH
unset CROSS_COMPILE
unset QEMU_LD_PREFIX

echo "[I] Cleaning buildroot..."
make -j $NUMCORES clean || echo "Nothing to clean"

echo "[I] Configuring..."
cp $ORIG/config/uclibc.conf $ORIG/resources/buildroot/package/uclibc/uClibc-snapshot.config.pinas
cp $ORIG/config/buildroot.conf ./.config

make -j $NUMCORES oldconfig

echo "[I] Building..."
make -j $NUMCORES toolchain








