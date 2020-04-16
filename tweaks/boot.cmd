if test ${mmc_bootdev} -eq 0 ; then
	echo "Booting from SD";
	setenv linux_mmcdev 0;
else
	echo "Booting from eMMC";
	setenv linux_mmcdev 2;
fi;

setenv bootargs console=ttyS0,115200 no_console_suspend panic=10 consoleblank=0 loglevel=7 root=/dev/mmcblk${linux_mmcdev}p1 ro splash plymouth.ignore-serial-consoles vt.global_cursor_default=0

led 1 on

echo "Loading kernel..."
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} /boot/Image.gz

echo "Uncompressing kernel..."
unzip ${ramdisk_addr_r} ${kernel_addr_r}

echo "Loading initramfs..."
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} /boot/initrd.img
setenv ramdisk_size ${filesize}

echo "Loading dtb..."
load mmc ${mmc_bootdev}:1 ${fdt_addr_r} /boot/dtb/${fdtfile}

led 2 on

echo "Booting..."
booti ${kernel_addr_r} ${ramdisk_addr_r}:0x${ramdisk_size} ${fdt_addr_r}
