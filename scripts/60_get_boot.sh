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
PNAME="boot blob"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh

if [ -d $ORIG/firmware ];then
	echo_info "Updating boot files..."
	cd $ORIG/firmware
	git pull origin master
	cd - >/dev/null
else
	echo_info "Cloning boot files from repo..."
	git init firmware
	cd $ORIG/firmware
	git remote add -f origin https://github.com/raspberrypi/firmware/

	git config core.sparsecheckout true
	echo boot/ >> .git/info/sparse-checkout
	git pull origin master
	cd - >/dev/null
fi

