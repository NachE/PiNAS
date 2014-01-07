PiNAS
=====

NAS Linux Distribution builded from scratch for Raspberry Pi.


Building Distro
===============
This Distro is based on a build system, so we dont have repositories with the source code. Instead we have a build systen which download source, configure and install. Also this build system make images to be installed into SD card ready to boot.

Necesary packages before build (debian package names): binfmt-support qemu qemu-user-static squashfs-tools
