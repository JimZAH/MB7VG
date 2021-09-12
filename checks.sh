#!/bin/bash

#LAMPS
OK_LED=14
DCD_LED=24

# IF FIRST TIME

if [[ $1 == "-b" ]]; then
	# GPIO SET UP 
	echo "$OK_LED" > /sys/class/gpio/export
	echo "$DCD_LED" > /sys/class/gpio/export
	echo "out" > /sys/class/gpio/gpio$OK_LED/direction
	echo "out" > /sys/class/gpio/gpio$DCD_LED/direction

	# WAIT FOR SERVICES TO START
	for i in {1..15}; do
		echo "0" > /sys/class/gpio/gpio$OK_LED/value
        	echo "1" > /sys/class/gpio/gpio$DCD_LED/value
		sleep 0.5
        	echo "1" > /sys/class/gpio/gpio$OK_LED/value
        	echo "0" > /sys/class/gpio/gpio$DCD_LED/value
		sleep 0.5
	done
fi

# CHECKS

# DIREWOLF
systemctl status direwolf > /dev/null

if [[ $? == 0 ]]; then
	echo "1" > /sys/class/gpio/gpio$OK_LED/value
else
        echo "0" > /sys/class/gpio/gpio$OK_LED/value
	exit
fi

# SSH CONNECTION

sc=$(netstat -atp | grep 'ESTABLISHED' | grep ssh)

if [ ! -z "$sc" ]; then
	for i in {1..50}; do
		echo "0" > /sys/class/gpio/gpio$OK_LED/value
		sleep 0.2
		echo "1" > /sys/class/gpio/gpio$OK_LED/value
		sleep 0.2
		echo "0" > /sys/class/gpio/gpio$OK_LED/value
		sleep 0.2
		echo "1" > /sys/class/gpio/gpio$OK_LED/value
		sleep 0.2
	done
fi
