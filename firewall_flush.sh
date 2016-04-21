#!/bin/bash

# fw_flush.sh - Flush current firewall. 

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
# $Id: fw_flush.sh,v 1.0 2011/09/21 15:00:05 blueflux Exp $

# Define variables.

ipt="/sbin/iptables"

# Set some kernel protections to default value.

echo 0 > /proc/sys/net/ipv4/tcp_syncookies
echo 0 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

# Flush all active rules and delete all pre-loaded chains.

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

$ipt -P INPUT ACCEPT
$ipt -P FORWARD ACCEPT
$ipt -P OUTPUT ACCEPT

exit 0
