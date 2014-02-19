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
	echo -e '\E[37;32m'"\033[1m[I] ===> $1\033[0m"
}

function exit_msg {
	echo -e '\E[37;31m'"\033[1m[E] !!!> $1\033[0m"
}

# $1 repository, $2 branch, $3 directory
function git_down_upd {
	if [ -d $3 ];then
		echo_info "Updating..."
		cd $3
		echo_info "Switching to branch $2"
		git checkout $2
		git pull
		cd - >/dev/null
	else
		echo_info "Cloning..."
		git clone $1 $3
		cd $3
		echo_info "Switching to branch $2"
		git checkout $2
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
