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

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)



function echo_info {
	[ -n "$PNAME" ] || PNAME="??"
	echo -e '\E[37;32m'"\033[1m[I] ===> [$PNAME] $1\033[0m"
}

function exit_msg {
	[ -n "$PNAME" ] || PNAME="??"
	echo -e '\E[37;31m'"\033[1m[E] !!!> [$PNAME] $1\033[0m"
	exit 1
}

# $1 repository, $2 branch, $3 directory
function git_down_upd {
	mkdir -p $(dirname $3)
	if [ -d $3 ];then
		cd $3
		if [ $2 == "." ];then
			echo_info "Resetting git dir..."
			git checkout .
		else
			echo_info "Resetting git dir..."
			git checkout .
			echo_info "Switching to branch $2..."
			git checkout $2
		fi
		echo_info "Updating..."
		git pull
		cd - >/dev/null
	else
		echo_info "Cloning..."
		git clone $1 $3
		cd $3
		if [ $2 == "." ];then
			echo_info "Resetting git dir..."
			git checkout .
		else
			echo_info "Resetting git dir..."
			git checkout .
			echo_info "Switching to branch $2..."
			git checkout $2
		fi
		cd - >/dev/null
	fi
}

# $1 repository, $2 branch, $3 directory
function hg_down_upd {
	mkdir -p $(dirname $3)
	if [ -d $3 ];then
		cd $3
		if [ $2 == "." ];then
			echo_info "Resetting hg dir..."
			hg update -C
                else
			echo_info "Resetting hg dir..."
			hg update -C
			echo_info "Switching to branch $2..."
			hg update -C $2
		fi
		echo_info "Updating..."
		hg pull
		cd - >/dev/null
        else
		echo_info "Cloning..."
		hg clone $1 $3
                cd $3
		if [ $2 == "." ];then
			echo_info "Resetting hg dir..."
			hg update -C
		else
			echo_info "Resetting hg dir..."
			hg update -C
			echo_info "Switching to branch $2..."
			hg update -C $2
		fi
		cd - >/dev/null
	fi
}

function get_qemu_arm_path {
	if [ -f $ORIG/host/bin/qemu-arm ]; then
		echo "$ORIG/host/bin/qemu-arm"
	elif [ -f /usr/bin/qemu-arm-static ]; then
		echo "/usr/bin/qemu-arm-static"
	elif [ -f /usr/bin/qemu-arm ]; then
		echo "/usr/bin/qemu-arm"
	else
		echo ""
	fi
}

function down_busybox {
	git_down_upd $BUSYBOX_URL $BUSYBOX_BRANCH $BUSYBOX_DIR
}

function down_linux {
	git_down_upd $LINUX_URL $LINUX_BRANCH $LINUX_DIR
}

function down_uclibc {
	git_down_upd $UCLIBC_URL $UCLIBC_BRANCH $UCLIBC_DIR
}

function down_python {
	hg_down_upd $PYTHON_URL $PYTHON_BRANCH $PYTHON_DIR
}

function down_samba {
	git_down_upd $SAMBA_URL $SAMBA_BRANCH $SAMBA_DIR
}

function down_dropbear {
	hg_down_upd $DROPBEAR_URL $DROPBEAR_BRANCH $DROPBEAR_DIR
}

