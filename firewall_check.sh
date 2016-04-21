#!/bin/bash
#
# BOF

FILE="/tmp/firewall.pid"
FIREWALL="/etc/init.d/firewall"
LOG="/var/log/messages"

if [ -f $FILE ]
then
	echo "Firewall is up and running" > $LOG
else
	$FIREWALL start
fi

exit 0

# EOF

