#!/bin/sh

echo "Enabling EG25 WWAN module"
# GPIO35 is PWRKEY
# GPIO68 is RESET_N
# GPIO232 is W_DISABLE#
for i in 35 68 232
do
	[ -e /sys/class/gpio/gpio$i ] && continue
	echo $i > /sys/class/gpio/export || return 1
	echo out > /sys/class/gpio/gpio$i/direction || return 1
done

echo 0 > /sys/class/gpio/gpio68/value || return 1
echo 0 > /sys/class/gpio/gpio232/value || return 1

( echo 1 > /sys/class/gpio/gpio35/value && sleep 2 && echo 0 > /sys/class/gpio/gpio35/value ) || return 1
