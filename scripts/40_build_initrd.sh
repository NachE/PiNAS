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

PNAME="initrd"
ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_config/environment_vars.sh
. $ORIG/scripts_functions/general.sh


sudo rm -rf $INITRAMFSDIR
mkdir $INITRAMFSDIR
sudo mkdir -p $INITRAMFSDIR/{bin,sbin,etc,proc,sys,dev,tmp,run,root,media,var,lib}
sudo mkdir -p $INITRAMFSDIR/usr/{bin,sbin}
sudo chmod 777 $INITRAMFSDIR/tmp

sudo rm -rf $INITRAMFSDIR/dev/console
sudo mknod -m 622 $INITRAMFSDIR/dev/console c 5 1
sudo rm -rf $INITRAMFSDIR/dev/tty0
sudo mknod -m 622 $INITRAMFSDIR/dev/tty0 c 4 0
sudo touch $INITRAMFSDIR/etc/mdev.conf

sudo cp $TARGETDIR/bin/busybox $INITRAMFSDIR/bin/


sudo cp $RESOURCESDIR/init $INITRAMFSDIR/
sudo chown root.root $INITRAMFSDIR/init
sudo chmod a+x $INITRAMFSDIR/init

cd $INITRAMFSDIR/bin/
sudo ln -sf busybox sh
cd - >/dev/null

cd $INITRAMFSDIR
sudo find ./ | cpio -H newc -o > ../initrd.cpio
cd - >/dev/null
gzip -c initrd.cpio > initrd.gz
