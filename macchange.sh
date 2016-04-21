#!/bin/bash

IFCONFIG="/sbin/ifconfig"
MAC="hw ether"

#for i in $#
#do 
#	echo $($i)
	#$IFCONFIG $($i) $MAC 00:$i$i:00:$i$i:00:$i$i
#done


$IFCONFIG $1 $MAC 00:11:22:33:44:55

exit 0
ifconfig | grep -i hwaddr | awk '{print $5}' # captura os macs das interfaces
