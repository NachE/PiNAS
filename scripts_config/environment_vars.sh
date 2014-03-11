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

[ -n "$ORIG" ] || ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_functions/general.sh


#General
NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
RESOURCESDIR="$ORIG/resources/"
TARGETDIR="$ORIG/target/"
INITRAMFSDIR="$ORIG/initramfs/"
HEADERS_TARGET_DIR="$ORIG/target_linux_headers"
HEADERSINCLUDE="$HEADERS_TARGET_DIR/include/"
CCPREFIX="$RESOURCESDIR/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabihf-"
LIBPATH="$RESOURCESDIR/buildroot/output/staging/"


#Config
BUSYBOX_URL="git://busybox.net/busybox.git"
BUSYBOX_BRANCH="."
BUSYBOX_DIR="$RESOURCESDIR/busybox"

LINUX_URL="https://github.com/raspberrypi/linux.git"
LINUX_BRANCH="."
LINUX_DIR="$RESOURCESDIR/raspberrypi/linux"

UCLIBC_URL="git://uclibc.org/uClibc.git"
UCLIBC_BRANCH="0.9.33"
UCLIBC_DIR="$RESOURCESDIR/uclibc"

PYTHON_URL="http://hg.python.org/cpython"
PYTHON_BRANCH="2.7"
PYTHON_DIR="$RESOURCESDIR/cpython"

SAMBA_URL="git.samba.org/samba.git"
SAMBA_BRANCH="v4-0-stable"
SAMBA_DIR="$RESOURCESDIR/samba"

DROPBEAR_URL="https://secure.ucc.asn.au/hg/dropbear"
DROPBEAR_BRANCH="."
DROPBEAR_DIR="$RESOURCESDIR/dropbear"


echo -e "\n"
echo_info "********** ENVIRONMENT VARS INFO *********"
echo_info "*"
echo_info "* You can change these values on $ORIG/scripts_config/environment_vars.sh"
echo_info "* NUMCORES: $NUMCORES"
echo_info "* RESOURCESDIR: $RESOURCESDIR"
echo_info "* TARGETDIR: $TARGETDIR"
echo_info "* INITRAMFS: $INITRAMFSDIR"
echo_info "* HEADERS_TARGET_DIR: $HEADERS_TARGET_DIR"
echo_info "* HEADERSINCLUDE: $HEADERSINCLUDE"
echo_info "* CCPREFIX: $CCPREFIX"
echo_info "* LIBPATH: $CCPREFIX"
echo_info "*"
echo_info "****** END OF ENVIRONMENT VARS INFO ******\n"

