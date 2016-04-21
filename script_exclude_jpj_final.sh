#!/bin/bash

# This script search and exclude old files.
#
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
# $Id: script_exclude.sh,v 1.0 2011/10/20 22:00:13

DAYS="+15"
#PATH="/home/nagot/teste/"
MOUNT="/bin/mount -t ext3"
SDB1="/dev/sdb1"
SDC1="/dev/sdc1"
SDD1="/dev/sdd1"
BACKUP1="/mnt/backup1"
BACKUP2="/mnt/backup2"
BACKUP3="/mnt/backup3"
PATH="/mnt/"
FNAME="tes*"
ECHO="/bin/echo"
RM="/bin/rm -v"
DATE="/bin/date"
FIND="/usr/bin/find"
LOG="/var/log/script_exclude.log"

$MOUNT $SDB1 $BACKUP1
$MOUNT $SDC1 $BACKUP2
$MOUNT $SDD1 $BACKUP3

if [ -z $LOG ]; then

	touch $LOG ; chmod 400 $LOG 
	
fi

$DATE >> $LOG
$ECHO >> $LOG
$FIND $PATH -iname "$FNAME" -mtime $DAYS -exec $RM {} \; >> $LOG
$ECHO >> $LOG
$ECHO >> $LOG

exit 0
