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

PNAME="python"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

down_python

echo_info "Making CONFIG_SITE file..."
echo -e "ac_cv_file__dev_ptmx=no\nac_cv_file__dev_ptc=no\n" > $RESOURCESDIR/cpython/configsite.pinas
cd $ORIG

echo_info "Setting special env vars"
# On CentOS you can use "scl enable python27 bash" after install python27 with scl
# or maybe you want to build fresh version... (recomended)
PYTHONLIBPATH1=$(python-config --prefix)/lib/
PYTHONLIBPATH2=$(python-config --prefix)/lib64/

echo_info "$PNAME Setting up arm binfmt..."
sudo $ORIG/scripts_utils/enable_arm_binfmt.sh

echo_info "$PNAME Compiling python..."
cd $RESOURCESDIR/cpython

make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH="${LIBPATH}usr/lib/;$PYTHONLIBPATH1;$PYTHONLIBPATH2" LDFLAGS="-L${LIBPATH}usr/lib/" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} clean || echo "Nothing to clean"

echo_info "$PNAME Configuring src before build..."
ARCH=arm CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH="${LIBPATH}usr/lib/;$PYTHONLIBPATH1;$PYTHONLIBPATH2" LDFLAGS="-L${LIBPATH}usr/lib/" CROSS_COMPILE=${CCPREFIX} CONFIG_SITE=configsite.pinas QEMU_LD_PREFIX=${LIBPATH} ./configure --prefix=${LIBPATH}  --host=arm-linux --build=i686-pc-linux-gnu --enable-shared --disable-ipv6 --without-pydebug --disable-nis 

echo_info "$PNAME Building..."
make -j 1 CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH="${LIBPATH}usr/lib/;$PYTHONLIBPATH1;$PYTHONLIBPATH2" LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH}

#[ -d $ORIG/target_python ] || mkdir $ORIG/target_python

echo_info "$PNAME Installing..."
make -j $NUMCORES PATH="$LIBPATH/bin:$PATH" CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH="${LIBPATH}usr/lib/" LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} install



