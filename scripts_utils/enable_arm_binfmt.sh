#!/bin/bash
#extracted from scripts/qemu-binfmt-conf.sh on git://git.qemu-project.org/qemu.git

set -e

ORIG=$(cd $(dirname "$0")/../; pwd)
. $ORIG/scripts_functions/general.sh

if [ -z "$1" ]; then
	if [ -f $ORIG/host/bin/qemu-arm ]; then
		QUEMUARMPATH=$ORIG/host/bin/qemu-arm
	elif [ -f /usr/bin/qemu-arm-static ]; then
		QUEMUARMPATH=/usr/bin/qemu-arm-static
	elif [ -f /usr/bin/qemu-arm ]; then
		QUEMUARMPATH=/usr/bin/qemu-arm
	else
		exit_msg "No qemu-arm found :("
	fi

else
	QUEMUARMPATH=$1
fi

# load the binfmt_misc module
if [ ! -d /proc/sys/fs/binfmt_misc ]; then
  /sbin/modprobe binfmt_misc
fi
if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
  mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
fi

if [ -f /proc/sys/fs/binfmt_misc/armPinas ];then
	echo -1 >/proc/sys/fs/binfmt_misc/armPinas
fi

#https://www.kernel.org/doc/Documentation/binfmt_misc.txt
echo_info ":armPinas:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:$QUEMUARMPATH: > /proc/sys/fs/binfmt_misc/register"
echo ":armPinas:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:$QUEMUARMPATH:" > /proc/sys/fs/binfmt_misc/register

