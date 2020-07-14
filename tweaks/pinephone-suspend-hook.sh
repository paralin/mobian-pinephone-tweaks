#!/bin/sh

prepare_suspend() {
	# Put modem in power saving mode
	echo -ne 'AT+QSCLK=1\r' > /dev/ttyS2
	echo 1 > /sys/class/gpio/gpio358/value

	# Disable Bluetooth module (fixes kernel OOPS)
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/unbind
}

resume_all() {
	# Wake up modem
	echo 0 > /sys/class/gpio/gpio358/value
	echo -ne 'AT+QSCLK=0\r' > /dev/ttyS2

	# Restore system time from RTC
	hwclock -s

	# Re-enable Bluetooth module
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/bind
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
