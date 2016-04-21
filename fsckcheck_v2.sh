#!/bin/bash

# BOF

# Script execute fsck on the next system boot
# ----------------------------------------------------------
# Made by Lonegunman21 - 2012
# ----------------------------------------------------------
# This script is licensed under GNU GPL version 2.0 or above
# ----------------------------------------------------------

tune2fs="/sbin/tune2fs"
shutdown="/sbin/shutdown -r now"

echo "Setting hard disk partitions to be checked on the next boot..."
sleep 1 

for i in $(seq 1 $(df -h | grep -i sda | cut -f 3 -d "/" | wc -l))
do
	$tune2fs -c 20 /dev/$(df -h | grep -i sda | cut -f 3 -d "/" | cut -f 1 -d " " | sed -n ''$i'p')
	$tune2fs -C 20 /dev/$(df -h | grep -i sda | cut -f 3 -d "/" | cut -f 1 -d " " | sed -n ''$i'p')
done

echo "Would you like to reboot your system in order to proceed with the disk verification? (yes/no)"
read answer

if [ $answer = yes ] 
then
	echo "The system will reboot now!"
	sleep 1
	$shutdown
else
	echo "The disk partitions will be tested on the next boot"
fi
	
exit 0

# EOF
