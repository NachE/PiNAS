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

PNAME="busybox"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

git_down_upd //git.samba.org/samba.git v4-0-stable $RESOURCESDIR/samba
cd $RESOURCESDIR/samba

echo_info "Setting up special env vars..."
QEMUARMBIN=$(get_qemu_arm_path)

LIBPATH_PYTHON=$LIBPATH/lib/
PYTHONINCLUDE=$LIBPATH/include/python2.7/
PYTHON_CFG_BINARY=$RESOURCESDIR/buildroot/output/staging/bin/python-config

#####################

echo_info "Cleaning..."

PYTHON_CONFIG="${PYTHON_CFG_BINARY}" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" \
	CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" \
	AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" \
	LDFLAGS="-L${LIBPATH}lib/ -L${LIBPATH_PYTHON}" ARCH=arm CROSS_COMPILE="${CCPREFIX}" \
	QEMU_LD_PREFIX="${LIBPATH}" C_INCLUDE_PATH="${PYTHONINCLUDE}" \
	python buildtools/bin/waf clean || echo "Nothing to clean"

#####################

echo_info "Setting up arm binfmt..."
sudo $ORIG/scripts_utils/enable_arm_binfmt.sh

echo_info "Configuring src before build..."
echo_info "Using ${LIBPATH} as elf interpreter prefix..." 

#####################
PYTHON_CONFIG="${PYTHON_CFG_BINARY}" ARCH="arm" CC="${CCPREFIX}gcc" \
	CPP="${CCPREFIX}cpp" CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" \
	NM="${CCPREFIX}nm" AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" \
	LDFLAGS="-L${LIBPATH}lib/ -L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" \
	CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" \
	C_INCLUDE_PATH="${PYTHONINCLUDE}" buildtools/bin/waf configure \
		--without-gettext \
		--without-winbind \
		--without-ads \
		--without-ldap \
		--disable-cups \
		--disable-iprint \
		--without-pam \
		--without-pam_smbpass \
		--without-quotas \
		--without-sendfile-support \
		--without-utmp \
		--disable-avahi \
		--with-iconv \
		--without-acl-support \
		--without-dnsupdate \
		--without-automount \
		--without-aio-support \
		--without-dmapi \
		--without-fam \
		--without-profiling-data \
		--without-cluster-support \
		--without-ad-dc \
		--disable-gnutls \
		--without-pie \
		--nopyc \
		--nopyo \
		--fatal-errors \
		--prefix=$TARGETDIR \
		--cross-compile \
		--cross-execute="$QEMUARMBIN -L ${LIBPATH}" \
		--destdir=$TARGETDIR \
		--disable-ntdb \
		--disable-pthreadpool \
		--disable-rpath \
		--disable-rpath-install \
		--disable-rpath-private-install \
# Future options: --without-regedit --disable-glusterfs
#####################

echo_info "Building..."
PYTHON_CONFIG="${PYTHON_CFG_BINARY}" CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" \
	CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" \
	AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib"  \
	LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH}lib/ -L${LIBPATH_PYTHON}" \
	ARCH="arm" CROSS_COMPILE="${CCPREFIX}" QEMU_LD_PREFIX="${LIBPATH}" \
	C_INCLUDE_PATH="${PYTHONINCLUDE}" \
	buildtools/bin/waf -vvv build -j $NUMCORES

#####################


echo_info "Installing..."
sudo PYTHON_CONFIG=${PYTHON_CFG_BINARY} CC="${CCPREFIX}gcc" CPP="${CCPREFIX}cpp" \
	CXX="${CCPREFIX}g++" LD="${CCPREFIX}ld" NM="${CCPREFIX}nm" \
	AR="${CCPREFIX}ar" RANLIB="${CCPREFIX}ranlib" \
	LD_LIBRARY_PATH=${LIBPATH}usr/lib/ \
	LDFLAGS="-L${LIBPATH}usr/lib/ -L${LIBPATH_PYTHON}" \
	ARCH=arm CROSS_COMPILE=${CCPREFIX} QEMU_LD_PREFIX=${LIBPATH} \
	C_INCLUDE_PATH=${PYTHONINCLUDE} \
	buildtools/bin/waf install -j $NUMCORES

#####################



