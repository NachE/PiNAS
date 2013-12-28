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

echo "[I] Building initrd.gz..."

[ -d $PWD/initramfs ] || mkdir $PWD/initramfs
mkdir -p $PWD/initramfs/{bin,sbin,etc,proc,sys,dev,tmp,run,root,media,var,lib}
mkdir -p $PWD/initramfs/usr/{bin,sbin}
chmod 777 $PWD/initramfs/tmp

rm -rf $PWD/initramfs/dev/console
mknod -m 622 $PWD/initramfs/dev/console c 5 1
rm -rf $PWD/initramfs/dev/tty0
mknod -m 622 $PWD/initramfs/dev/tty0 c 4 0
touch $PWD/initramfs/etc/mdev.conf
cp $PWD/target/bin/busybox $PWD/initramfs/bin/
cp $PWD/resources/init $PWD/initramfs/
chmod a+x $PWD/initramfs/init
cd $PWD/initramfs/bin/
ln -sf busybox sh
cd - >/dev/null
cd $PWD/initramfs
find ./ | cpio -H newc -o > ../initrd.cpio
cd - >/dev/null
gzip -c initrd.cpio > initrd.gz
