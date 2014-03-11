base:
	scripts/00_getbase_download.sh
	scripts/01_getbase_busybox.sh
	scripts/02_getbase_kernel_headers.sh
	scripts/03_getbase_uclibc.sh
	scripts/04_getbase_python.sh
	scripts/05_getbase_samba.sh
	scripts/06_getbase_dropbear.sh
download:
	scripts/00_getbase_download.sh
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
	@echo  '  all             - Run all. Disabled.'
	@echo  '  base            - Build base (busybox, uclibc, *python, samba)'
	@echo  '  download        - (00 base) Download all src resources files you need git, hg and cvs'
	@echo  '  upchroot        - (01 base) Build busybox'
	@echo  '  kernel_headers  - (02 base) Download kernel src and install headers on target_linux_headers'
	@echo  '  uclibc          - (03 base) Build uclibc libc libraries'
	@echo  '  python          - (04 base) Build python, install on buildroot instead target'
	@echo  '  samba           - (05 base) Build samba'
	@echo  '  dropbear        - (06 base) Build dropbear'
	@echo  '  kernel          - (30) Download linux src and build kernel/modules'
	@echo  '  initrd          - (40) Create an initrd.gz'
	@echo  '  rootfs          - (50) compress target with squashfs'
	@echo  '  boot            - (60) Download boot files'
	@echo  '  help            - This'
	@echo ' '
	@echo '*Python is builded because samba requered it. No python binary or libs are added to target'

