#!/bin/bash

## /usr/local/sbin/fw_netbook

# fw_desktop.sh - This firewall blocks all connect attempts of external services. 
# It only leaves open local LAN file transfers protocols, like samba, nfs, Network time protocol and Cups. 
# Remembering that, this firewall is design for note/netbooks and desktops security ONLY. DON'T USE
# as a network firewall.

# Copyright (C) 2011 Ian Nagot
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
# USA
#
# $Id: fw_desktop.sh,v 1.0 2011/09/21 15:00:05 blueflux Exp $


# Define variables. Note you can change the $LAN and $WLAN to your needs. You can also add new interfaces.

ipt="/sbin/iptables"
mod="/sbin/modprobe"
LAN="eth0"
#LAN1="eth1" # Custom interface, you may use it if you need.
WLAN="wlan0"
PORTS=`cat /tmp/portas` # Put here the ports you want to be left open
#PORTS=`cat /tmp/ports`
SIZE=`wc -w /tmp/ports | cut -d ' ' -f 1`

#echo $PORTS > /tmp/portas
# Set some kernel protections against Syn-Flood and Smurf

echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Create registered ports

echo $REG_PORTS > /tmp/ports ; chmod 400 /tmp/ports

# Loading Kernel modules

$mod ip_tables
$mod ip_conntrack #may unload
$mod iptable_filter
#$mod iptable_nat #may unload
#$mod iptable_mangle #may unload
$mod ipt_LOG
$mod ipt_limit #may unload
$mod ipt_state #may unload
#$mod ipt_MASQUERADE #may unload

# Flush all active rules and delete all pre-loaded chains

$ipt -F
$ipt -t nat -F
$ipt -t mangle -F
$ipt -X
$ipt -t nat -X
$ipt -t mangle -X
$ipt -Z
$ipt -t nat -Z
$ipt -t mangle -Z

# Setting default policies

$ipt -P INPUT DROP
$ipt -P FORWARD DROP
$ipt -P OUTPUT ACCEPT
#$ipt -t nat -P OUTPUT ACCEPT
#$ipt -t nat -P PREROUTING ACCEPT
#$ipt -t nat -P POSTROUTING ACCEPT
#$ipt -t mangle -P PREROUTING ACCEPT
#$ipt -t mangle -P POSTROUTING ACCEPT

# This line is a MUST. You have to leave loopback interface police ACCEPT to all internal socket-based
# services work properly.

$ipt -A INPUT -i lo -j ACCEPT

# Enable unrestricted outgoing traffic, incoming is restricted to locally-initiated sessions only and
# drop connections that are not SYN flagged.

$ipt -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$ipt -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
#$ipt -A INPUT -i $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
#$ipt -A INPUT -i $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT # In case you want to add a new NIC.

# This line accept connections on the ports registered in the variable $GOODPORTS. You may add new ports on this
# Protection agains DOS and enable simple ping messages.

$ipt -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
$ipt -A INPUT -p icmp -j DROP

# variable. Keep in mind that iptables seems to doesn't like more than 15 ports in one variable. If you need more
# than fifteen, create another variable.

#while [ $SIZE -ne 0 ] 
#do
#	PORTS=`cat /tmp/ports | cut -d ' ' -f $SIZE`
	$ipt -A INPUT -i $WLAN -p tcp -m multiport --dport $PORTS -j ACCEPT
	$ipt -A INPUT -i $WLAN -p udp -m multiport --dport $PORTS -j ACCEPT
	$ipt -A INPUT -i $WLAN -p tcp -m multiport --dport $PORTS -j ACCEPT
	$ipt -A INPUT -i $WLAN -p udp -m multiport --dport $PORTS -j ACCEPT
	#$ipt -A INPUT -p tcp -i $LAN --dport $PORTS -j ACCEPT # You may want to add another interface or variable.
	#$ipt -A INPUT -p udp -i $LAN --dport $PORTS -j ACCEPT # You may want to add another interface or variable.
#	let SIZE=SIZE-1
#done
#echo $REG_PORTS

exit 0
