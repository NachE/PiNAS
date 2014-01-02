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

if [ ! -d $PWD/raspberrypi ];then
	mkdir $PWD/raspberrypi
fi

if [ -d $PWD/raspberrypi/firmware ];then
	echo "[I] Updating boot files..."
	cd $PWD/raspberrypi/firmware
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning boot files from repo..."
	cd $PWD/raspberrypi
	git clone https://github.com/raspberrypi/firmware
	cd - >/dev/null
fi