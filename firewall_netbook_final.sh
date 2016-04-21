#!/bin/bash

## /usr/local/sbin/fw_netbook

# fw_desktop.sh - This firewall blocks all connect attempts of external services. 
# It only leaves open local LAN file transfers protocols, like samba, nfs. You may modify it as you want
# to use other services.
# Remembering that, this firewall is design for note/netbooks and desktops security only. DON'T USE IT
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
# $Id: fw_desktop.sh,v 1.0 2011/10/07 12:20:05


# Define variables. Note you can change the $LAN and $WLAN as you need. You can also add new interfaces.

ipt="/sbin/iptables"
mod="/sbin/modprobe"
LAN="eth0"
#LAN1="eth1" # Custom interface, you may use it if you need.
WLAN="wlan0"
PORTS="111,2049,4000,4001,4002,139" # Put here the ports you want to be left open.

# Set some kernel protections against Syn-Flood, Smurf and other protections.

echo 1 > /proc/sys/net/ipv4/tcp_syncookies
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route

# Loading Kernel modules.

$mod ip_tables
$mod ip_conntrack
$mod iptable_filter
$mod iptable_nat
$mod iptable_mangle
$mod ipt_LOG
$mod ipt_limit
$mod ipt_state
$mod ipt_MASQUERADE

set_police() {

# Flush all previous active rules and delete all pre-loaded chains.

$ipt -F
$ipt -t nat -F
$ipt -t mangle -F
$ipt -X
$ipt -t nat -X
$ipt -t mangle -X
$ipt -Z
$ipt -t nat -Z
$ipt -t mangle -Z

# Setting new policies.

$ipt -P INPUT DROP
$ipt -P FORWARD DROP
$ipt -P OUTPUT ACCEPT
$ipt -t nat -P OUTPUT ACCEPT
$ipt -t nat -P PREROUTING ACCEPT
$ipt -t nat -P POSTROUTING ACCEPT
$ipt -t mangle -P PREROUTING ACCEPT
$ipt -t mangle -P POSTROUTING ACCEPT

}

default_police() {

# Flush all active rules, delete all pre-loaded chains back to default.

$ipt -F
$ipt -t nat -F
$ipt -t mangle -F
$ipt -X
$ipt -t nat -X
$ipt -t mangle -X
$ipt -Z
$ipt -t nat -Z
$ipt -t mangle -Z

# Setting default policies.

$ipt -P INPUT ACCEPT
$ipt -P FORWARD ACCEPT
$ipt -P OUTPUT ACCEPT
$ipt -t nat -P OUTPUT ACCEPT
$ipt -t nat -P PREROUTING ACCEPT
$ipt -t nat -P POSTROUTING ACCEPT
$ipt -t mangle -P PREROUTING ACCEPT
$ipt -t mangle -P POSTROUTING ACCEPT

# Set sysctl to default.

echo 0 > /proc/sys/net/ipv4/tcp_syncookies
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects

}

# Show firewall status.

firewall_status() {

$ipt -t filter -L -v -n --line-numbers
$ipt -t nat -L -v -n --line-numbers
$ipt -t mangle -L -v -n --line-numbers

}

create_rules() {

# This line is a MUST. You have to leave loopback interface police ACCEPT to all internal socket-based
# services work properly.

$ipt -A INPUT -i lo -j ACCEPT

# Enable unrestricted outgoing traffic, incoming is restricted to locally-initiated sessions only and
# drop connections that are not SYN flagged and put it into a log file.

$ipt -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$ipt -A INPUT -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "New not syn:"
$ipt -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# Protection agains DOS (put into a log all attempts) and enable simple ping messages.

$ipt -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
$ipt -A INPUT -p icmp -j LOG --log-prefix "Ping DOA request:"
$ipt -A INPUT -p icmp -j DROP

# In this line left open all the ports listed in the variable $PORTS.
# Keep in mind that iptables seems to doesn't like more than 15 ports in one variable. If you need more
# than fifteen, create another variable and another line.

$ipt -A INPUT -p tcp -i $WLAN -m multiport --dport $PORTS -j ACCEPT
$ipt -A INPUT -p udp -i $WLAN -m multiport --dport $PORTS -j ACCEPT
$ipt -A INPUT -p tcp -i $LAN -m multiport --dport $PORTS -j ACCEPT
$ipt -A INPUT -p udp -i $LAN -m multiport --dport $PORTS -j ACCEPT
#$ipt -A INPUT -p tcp -i $LAN1 --dport $PORTS -j ACCEPT # You may want to add another interface or variable.
#$ipt -A INPUT -p udp -i $LAN1 --dport $PORTS -j ACCEPT # You may want to add another interface or variable.

}

# Create start | stop | restart | status

case "$1" in
	start)
	    echo ""
	    echo "Configuring the firewall... "
	    set_police && create_rules \
	    sleep 20
	    echo "Firewall configured!"
	    echo ""
	    touch /var/lock/iptables
	    ;;

	stop)
	    echo ""
	    echo "Stopping the firewall... "
	    default_police \
	    sleep 20
	    echo "Firewall stopped!"
	    echo ""
	    rm -rf /va/lock/iptables
	    ;;

	restart)
	    echo ""
	    echo "Restarting the firewall... "
	    echo ""
	    $0 stop
	    $0 start
	    ;;

	status)
	    firewall_status
	    ;;
	
	*)
	    echo "Use: $0 {start|stop|restart|status}"
esac
exit 0
