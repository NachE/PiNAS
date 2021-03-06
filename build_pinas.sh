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

echo -e "\n\n PiNAS builder  Copyright (C) 2013  J.A. Nache <ja@nache.net>"
echo " This program comes with ABSOLUTELY NO WARRANTY."
echo " This is free software, and you are welcome to redistribute it"
echo -e " under certain conditions. See LICENSE for more details.\n\n"

function msg_and_quit {
	echo "**************************************"
	echo "**************************************"
	echo "*************** ERROR*****************"
	echo "**************************************"
	echo "**************************************"
	echo "[E] An ERROR ocurred, Build aborted"

	for script in "scriptsend"/*
	do
		if [[ -x "$script" ]]; then
		        "$script"
	        fi
	done
        exit 1
}

for script in "scripts"/*
do
if [[ -x "$script" ]]; then
	"$script" || msg_and_quit
	fi
done

for script in "scriptsend"/*
	do
		if [[ -x "$script" ]]; then
			"$script"
		fi
	done
