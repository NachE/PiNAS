
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
	@echo  '  base            - Download base debian system'
	@echo  '  upchroot        - Mount proc, sys, etc and leave target to be used'
	@echo  '  downchroot      - Umount proc, sys, etc from target'
	@echo  '  kernel          - Download linux src, compiler an build kernel/modules'
	@echo  '  initrd          - Create an initrd.gz (inside chrooted target)'
	@echo  '  rootfs          - compress target with squashfs'
	@echo  '  boot            - Download boot files and configure parameters'
	@echo  '  help            - This'

