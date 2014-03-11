base:
	scripts/01_getbase_busybox.sh
	scripts/02_getbase_kernel_headers.sh
	scripts/03_getbase_uclibc.sh
	scripts/04_getbase_python.sh
	scripts/05_getbase_samba.sh
	scripts/06_getbase_dropbear.sh

busybox:
	scripts/01_getbase_busybox.sh
kernel_headers:
	scripts/02_getbase_kernel_headers.sh
uclibc:
	scripts/03_getbase_uclibc.sh
python:
	scripts/04_getbase_python.sh
samba:
	scripts/05_getbase_samba.sh
dropbear:
	scripts/06_getbase_dropbear.sh

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
	@echo  '  base            - Build base (busybox, uclibc, *python, samba)'
	@echo  '  upchroot        - (00) Build busybox'
	@echo  '  kernel_headers  - (01) Download kernel src and install headers on target_linux_headers'
	@echo  '  uclibc          - (02) Build uclibc libc libraries'
	@echo  '  python          - (03) Build python, install on buildroot instead target'
	@echo  '  samba           - (04) Build samba'
	@echo  '  dropbear        - (05) Build dropbear'
	@echo  '  kernel          - (30) Download linux src and build kernel/modules'
	@echo  '  initrd          - (40) Create an initrd.gz'
	@echo  '  rootfs          - (50) compress target with squashfs'
	@echo  '  boot            - (60) Download boot files'
	@echo  '  help            - This'
	@echo ' '
	@echo '*Python is builded because samba requered it. No python binary or libs are added to target'

