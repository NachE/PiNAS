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
PNAME="samba"

cd resources/
if [ -d $PWD/samba ];then
	echo "[I] Updating samba src..."
	cd $PWD/samba
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning samba src..."
	git clone git://git.samba.org/samba.git
	echo "[I] Switching to v4-0-stable..."
	cd $PWD/samba
	git checkout v4-0-stable
fi
cd $ORIG

QEMUARMBIN=$(get_qemu_arm_path)

CCPREFIX=$ORIG/resources/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabihf-
#CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-

LIBPATH=$ORIG/resources/buildroot/output/staging/
#LIBPATH=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/

LIBPATH_PYTHON=$LIBPATH/lib/
#C_INCLUDE_PATH=$ORIG/target_python/include/python2.7/
#C_INCLUDE_PATH=${PYTHONINCLUDE}
PYTHONINCLUDE=$LIBPATH/include/python2.7/
PYTHON_CFG_BINARY=$ORIG/resources/buildroot/output/staging/bin/python-config

#CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}/usr/lib/ LDFLAGS="-L${LIBPATH}/usr/lib/"

cd resources/samba

#####################
#make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} C_INCLUDE_PATH=${PYTHONINCLUDE} clean || echo "Nothing to clean"
#

echo_info "$PNAME Cleaning..."
#PYTHON_CONFIG="${PYTHON_CFG_BINARY}" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH="${LIBPATH}usr/lib/" LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" C_INCLUDE_PATH="${PYTHONINCLUDE}" python buildtools/bin/waf clean || echo "Nothing to clean"

PYTHON_CONFIG="${PYTHON_CFG_BINARY}" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LDFLAGS="-L${LIBPATH}lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" C_INCLUDE_PATH="${PYTHONINCLUDE}" python buildtools/bin/waf clean || echo "Nothing to clean"

#####################

echo_info "$PNAME Setting up arm binfmt..."
sudo $ORIG/scripts_utils/enable_arm_binfmt.sh

echo_info "$PNAME Configuring src before build..."
echo_info "$PNAME Using ${LIBPATH} as elf interpreter prefix..." 

#####################
PYTHON_CONFIG="${PYTHON_CFG_BINARY}" ARCH="arm" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LDFLAGS="-L${LIBPATH}lib/ -L${LIBPATH_PYTHON}" CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" C_INCLUDE_PATH="${PYTHONINCLUDE}" buildtools/bin/waf configure --without-gettext --without-winbind --without-ads --without-ldap --disable-cups --disable-iprint --without-pam --without-pam_smbpass --without-quotas --without-sendfile-support --without-utmp --disable-avahi --with-iconv --without-acl-support --without-dnsupdate --without-automount --without-aio-support --without-dmapi --without-fam --without-profiling-data --without-cluster-support --without-ad-dc --disable-gnutls --without-pie --nopyc --nopyo --fatal-errors --prefix=$ORIG/target/ --cross-compile --cross-execute="$QEMUARMBIN -L ${LIBPATH}" --destdir=$ORIG/target/ --disable-ntdb --disable-pthreadpool --disable-rpath --disable-rpath-install --disable-rpath-private-install
# Future options: --without-regedit --disable-glusterfs
#####################

#####################
#make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} C_INCLUDE_PATH=${PYTHONINCLUDE}
#

echo_info "$PNAME Building..."
PYTHON_CONFIG="${PYTHON_CFG_BINARY}" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib"  LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}lib/ -L${LIBPATH_PYTHON}" ARCH="arm" CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" C_INCLUDE_PATH="${PYTHONINCLUDE}" buildtools/bin/waf -vvv build -j $NUMCORES
#####################


#####################
#make -j $NUMCORES CC="${CCPREFIX}gcc" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} C_INCLUDE_PATH=${PYTHONINCLUDE} install
#

echo_info "$PNAME Installing..."
PYTHON_CONFIG=${PYTHON_CFG_BINARY} CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" LD_LIBRARY_PATH=${LIBPATH}usr/lib/ LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} C_INCLUDE_PATH=${PYTHONINCLUDE} buildtools/bin/waf install -j $NUMCORES
#####################



#CCPREFIX=$ORIG/raspberrypi/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
#echo "[I] CC prefix: $CCPREFIX"
#NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
#echo "[I] CPU Cores: $NUMCORES"

#cd $PWD/resources/busybox/
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX} clean
#cp $ORIG/config/busybox.conf ./.config
#make -j $NUMCORES ARCH=arm CROSS_COMPILE=${CCPREFIX}
#cd $ORIG








