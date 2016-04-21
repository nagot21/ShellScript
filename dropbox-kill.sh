#!/bin/bash

# BOF

SSID=`iwconfig wlan0 | grep -i essid | cut -d '"' -f 2`
LOAD=`w | grep -i load | cut -d " " -f 12 | cut -d "," -f 1`
TARGET="Nagot"
#TARGET="FATECSCS"
LDEFAULT="4.00"
AUX=`echo "$LOAD > $LDEFAULT" | bc`

if [ "$SSID" != "$TARGET" ]; then
#if [ "$SSID" = "$TARGET" ]; then
#	echo "Rede diferente de $TARGET, parar dropbox"
	dropbox stop
#	dropbox start

elif [ "$AUX" -eq 1 ]; then 
	echo "Rede certa, mas load avarage maior que $LDEFAULT"
	dropbox stop
#else
#      	echo "OK!"		
fi

# EOF
