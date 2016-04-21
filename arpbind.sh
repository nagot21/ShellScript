#!/bin/sh

# Customized arp-binding made by Lonegunman21 2014

TARGET=`ip n show | grep -i 192.168.1.250 | cut -d " " -f 1`
REF="192.168.1.250"

if [ "$TARGET" != "$REF" ]; then 

	ip neigh add 192.168.1.250 lladdr c8:60:00:59:bb:9e dev BR_LAN nud perm

fi

exit 0

