#!/bin/bash

########### SCRIPT DE SINCRONIZACAO DE DISCOS ###############

# Version 1.0

rsync -arv --delete /dev/sda1 /dev/sdb1 >> /var/log/rsync.log
rsync -arv --delete /dev/sda2 /dev/sdb2 >> /var/log/rsync.log
rsync -arv --delete /dev/sda3 /dev/sdb3 >> /var/log/rsync.log
rsync -arv --delete /dev/sda6 /dev/sdb6 >> /var/log/rsync.log

#hdparm -S 24 /dev/sdb

########### FIM DO SCRIPT ##############
