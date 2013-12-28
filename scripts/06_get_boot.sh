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

ORIG=$PWD

if [ ! -d raspberrypi/ ];then
	mkdir raspberrypi
fi
cd raspberrypi/

if [ -d $PWD/boot ];then
	echo "[I] Updating boot files..."
	cd $PWD/boot
	git pull
	cd - >/dev/null
else
	echo "[I] Cloning boot files..."
	git clone https://github.com/raspberrypi/tools.git
fi
