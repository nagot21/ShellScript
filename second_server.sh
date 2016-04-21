#!/bin/bash

#################################################################
#								#   
#								#
#			BACKUP SERVER SCRIPT			#
#								#
#	       	    made by Ian Nagot 09-09-11			#	
#								#
#################################################################

# Test if the first server is up and running
SERVER='192.168.137.1'

#ping -c 10 192.168.137.1 | grep -i received | cut -d ' ' -f 4 > /tmp/ping_status
ping -c 10 $SERVER | grep -i received | cut -d ' ' -f 4 > /tmp/ping_status

if [ 
