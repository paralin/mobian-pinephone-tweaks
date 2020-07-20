#!/bin/sh

prepare_suspend() {
	# Put modem in power saving mode
	# Note: GPIO231 is WAKEUP_IN on BH and AP_READY on CE
	#  - BH: WAKEUP_IN must be high to enable power saving mode
	#  - CE: AP_READY (active low) must be high to indicate host sleep
	# In both cases DTR (GPIO358) must be high to enable power saving mode
	echo 1 > /sys/class/gpio/gpio231/value
	echo 1 > /sys/class/gpio/gpio358/value
	echo -ne 'AT+QSCLK=1\r' > /dev/ttyS2

	# Disable Bluetooth module (fixes kernel OOPS)
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/unbind
}

resume_all() {
	# Restore system time from RTC
	hwclock -s

	# Re-enable Bluetooth module
	echo serial0-0 > /sys/bus/serial/drivers/hci_uart_h5/bind

	# Wake up modem
	echo -ne 'AT+QSCLK=0\r' > /dev/ttyS2
	echo 0 > /sys/class/gpio/gpio231/value
	echo 0 > /sys/class/gpio/gpio358/value
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
