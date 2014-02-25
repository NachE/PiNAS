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

NUMCORES=$(cat /proc/cpuinfo | grep vendor_id | wc -l)
RESOURCESDIR="$ORIG/resources/"
TARGETDIR="$ORIG/target/"
CCPREFIX="$RESOURCESDIR/buildroot/output/host/usr/bin/arm-buildroot-linux-uclibcgnueabihf-"
LIBPATH="$RESOURCESDIR/buildroot/output/staging/"

echo_info "NUMCORES: $NUMCORES"
echo_info "RESOURCESDIR: $RESOURCESDIR"
echo_info "TARGETDIR: $TARGETDIR"
echo_info "CCPREFIX: $CCPREFIX"
echo_info "LIBPATH: $CCPREFIX"

