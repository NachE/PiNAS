
all:
	build_pinas.sh	

base:
	scripts/00_getbase.sh

upchroot:
	scripts/01_preparechroot.sh
	scripts/02_configurechroot.sh

downchroot:
	scripts/09_finishchroot.sh
	scriptsend/00_umount.sh

joinchroot:
	DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot target/

kernel:
	scripts/03_build_kernel.sh

initrd:
	scripts/04_build_initrd.sh

rootfs:
	scripts/05_build_rootfs.sh

boot:
	scripts/06_get_boot.sh

help:
	@echo  '  all             - Exec build_pinas.sh'
	@echo  '  base            - (0) Download base debian system'
	@echo  '  upchroot        - (01,02) Mount proc, sys, etc and leave target to be used'
	@echo  '  downchroot      - (09) Umount proc, sys, etc from target'
	@echo  '  kernel          - (03) Download linux src, compiler an build kernel/modules'
	@echo  '  initrd          - (04) Create an initrd.gz (inside chrooted target)'
	@echo  '  rootfs          - (05) compress target with squashfs'
	@echo  '  boot            - (06) Download boot files and configure parameters'
	@echo  '  joinchroot      - Join into chroot env'
	@echo  '  help            - This'

