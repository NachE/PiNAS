#!/bin/bash
##############################################################################
#
#    PiNAS Linux Distribution builder
#    Copyright (C) 2013-2014 Juan Antonio Nache <ja@nache.net>
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

PNAME="dropbear"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

cd resources/
if [ -d $RESOURCESDIR/dropbear ];then
	echo "[I] Updating dropbear src..."
	cd $RESOURCESDIR/dropbear
	hg pull
	cd - >/dev/null
else
	echo "[I] Cloning dropbear src..."
	hg clone https://secure.ucc.asn.au/hg/dropbear
fi

cd $RESOURCESDIR/dropbear
autoconf
autoheader

echo_info "Cleaning..."
make CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"

echo_info "Configuring..."
ARCH=arm CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} ./configure --prefix=${TARGETDIR}  --host=arm-linux --build=i686-pc-linux-gnu --disable-zlib

echo_info "Building..."
make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}

echo_info "Installing..."
sudo make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} PREFIX=$TARGETDIR install


