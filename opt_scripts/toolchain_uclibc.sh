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

PNAME="toolchain"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

git_down_upd git://git.buildroot.net/buildroot 2013.08.x $RESOURCESDIR/buildroot
cd $RESOURCESDIR/buildroot

unset CCPREFIX
unset LIBPATH
unset CC
unset CPP
unset CXX
unset LD
unset NM
unset AR
unset RANLIB
unset ARCH
unset CROSS_COMPILE
unset QEMU_LD_PREFIX
unset LD_LIBRARY_PATH
unset LDFLAGS

echo_info "Cleaning buildroot..."
make clean || echo_info "Nothing to clean"
make distclean || echo_info "Nothing to clean"

echo_info "Configuring..."
cp $ORIG/config/uclibc.conf $ORIG/resources/buildroot/package/uclibc/uClibc-snapshot.config.pinas
cp $ORIG/config/buildroot.conf ./.config

make olddefconfig

echo_info "Building..."
make toolchain

