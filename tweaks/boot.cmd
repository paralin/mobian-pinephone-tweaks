if test ${mmc_bootdev} -eq 0; then
	echo "Booting from SD"
	setenv linux_mmcdev 0
else
	echo "Booting from eMMC"
	setenv linux_mmcdev 2
fi

# If we have at least 2 partitions, then the 1st one is /boot, and / is #2
if fstype mmc ${mmc_bootdev}:2; then
	setenv rootpart 2
else
	setenv rootpart 1
	setenv bootdir "/boot"
fi

setenv bootargs console=ttyS0,115200 no_console_suspend panic=10 consoleblank=0 loglevel=7 root=/dev/mmcblk${linux_mmcdev}p${rootpart} rw splash plymouth.ignore-serial-consoles vt.global_cursor_default=0

led 1 on

echo "Loading kernel..."
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} ${bootdir}/Image.gz

echo "Uncompressing kernel..."
unzip ${ramdisk_addr_r} ${kernel_addr_r}

echo "Loading initramfs..."
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} ${bootdir}/initrd.img
setenv ramdisk_size ${filesize}

echo "Loading dtb..."
load mmc ${mmc_bootdev}:1 ${fdt_addr_r} ${bootdir}/dtb/${fdtfile}

led 2 on

echo "Booting..."
booti ${kernel_addr_r} ${ramdisk_addr_r}:0x${ramdisk_size} ${fdt_addr_r}
