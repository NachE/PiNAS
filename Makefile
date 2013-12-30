
all:
	build_pinas.sh	

base:
	scripts/00_getbase.sh

upchroot:
	scripts/10_preparechroot.sh
	scripts/20_configurechroot.sh

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
	@echo  '  base            - (00) Download base debian system'
	@echo  '  upchroot        - (10,20) Mount proc, sys, etc and leave target to be used'
	@echo  '  downchroot      - (90) Umount proc, sys, etc from target'
	@echo  '  kernel          - (30) Download linux src, compiler an build kernel/modules'
	@echo  '  initrd          - (40) Create an initrd.gz (inside chrooted target)'
	@echo  '  rootfs          - (50) compress target with squashfs'
	@echo  '  boot            - (60) Download boot files and configure parameters'
	@echo  '  joinchroot      - Join into chroot env'
	@echo  '  help            - This'

