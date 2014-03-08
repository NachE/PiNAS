
all:
	build_pinas.sh	

base:
	scripts/00_getbase_busybox.sh
	scripts/01_getbase_kernel_headers.sh
	scripts/02_getbase_uclibc.sh
	scripts/03_getbase_python.sh
	scripts/04_getbase_samba.sh

busybox:
	scripts/00_getbase_busybox.sh
kernel_headers:
	scripts/01_getbase_kernel_headers.sh
uclibc:
	scripts/02_getbase_uclibc.sh
python:
	scripts/03_getbase_python.sh
samba:
	scripts/04_getbase_samba.sh

upchroot:
	scripts/10_preparechroot.sh

downchroot:
	scripts/90_finishchroot.sh
	scriptsend/00_umount.sh

joinchroot:
	DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot target/

kernel:
	scripts/30_build_kernel.sh

initrd:
	scripts/40_build_initrd.sh

rootfs:
	scripts/50_build_rootfs.sh

boot:
	scripts/60_get_boot.sh

help:
	@echo  '  all             - Exec build_pinas.sh'
	@echo  '  base            - (00) Build base (busybox, uclibc, *python, samba)'
	@echo  '  upchroot        - (10,20) Mount proc, sys, etc and leave target to be chrooted'
	@echo  '  downchroot      - (90) Umount proc, sys, etc from target'
	@echo  '  kernel          - (30) Download linux src, compiler an build kernel/modules'
	@echo  '  initrd          - (40) Create an initrd.gz (inside chrooted target)'
	@echo  '  rootfs          - (50) compress target with squashfs'
	@echo  '  boot            - (60) Download boot files and configure parameters'
	@echo  '  joinchroot      - Join into chroot env'
	@echo  '  help            - This'
	@echo ' '
	@echo '*Python is builded because samba requered it. No python binary is added to target'

