#!/bin/sh

if grep -q 1.1 /proc/device-tree/model
then
	DTR=358
else
	DTR=34
fi

prepare_suspend() {
	# Enable URC caching
	echo -ne 'AT+QCFG="urc/cache",1\r' > /dev/ttyS2

	# Put modem in power saving mode
	# Note: GPIO231 is WAKEUP_IN on BH and AP_READY on CE
	#  - BH: WAKEUP_IN must be high to enable power saving mode
	#  - CE: AP_READY (active low) must be high to indicate host sleep
	# In both cases DTR (GPIO358) must be high to enable power saving mode
	echo 1 > /sys/class/gpio/gpio231/value
	echo 1 > /sys/class/gpio/gpio$DTR/value
	echo -ne 'AT+QSCLK=1\r' > /dev/ttyS2
}

resume_all() {
	# Wake up modem
	echo -ne 'AT+QSCLK=0\r' > /dev/ttyS2
	echo 0 > /sys/class/gpio/gpio231/value
	echo 0 > /sys/class/gpio/gpio$DTR/value

	# Disable URC caching
	echo -ne 'AT+QCFG="urc/cache",0\r' > /dev/ttyS2
}

case $1 in
	pre) prepare_suspend ;;
	post) resume_all ;;
esac
