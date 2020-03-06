#!/bin/sh

echo "Disabling EG25 WWAN module"
echo 1 > /sys/class/gpio/gpio68/value
echo 1 > /sys/class/gpio/gpio232/value

echo 1 > /sys/class/gpio/gpio35/value && sleep 2 && echo 0 > /sys/class/gpio/gpio35/value
sleep 30 # Wait for the module to power off
