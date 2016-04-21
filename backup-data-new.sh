#!/bin/bash
#
################ Folder to folder backup script #################
# 
# Wrote by Ian Nagot in 01-26-11
#
# Version 1.1
#
#############
#
# Change Log
#
# Version 1.0
#
# Script Configurations
# Where, DIR_ORIG is the backup diretory and DIR_DEST is where the compacted
# files will be put on. BKP_NAME is the name of the compacted file.
#
# Version 1.1
#
# Implemented new variables an hdparm command.
#
###########################################################################


DIR_ORIG="/jpj/rede_z/"
DIR_DEST="/mnt/backup1/"
DIR_DEST_2="/mnt/backup2/"
SDB1="/dev/sdb1"
SDC1="/dev/sdc1"
LOG="/var/log/backup-data.log"
BKP_NAME=bkp_`date +%d-%m-%y`.tgz

# Mount volumes

mount -t ext4 $SDB1 $DIR_DEST
mount -t ext4 $SDC1 $DIR_DEST_2

#Compression of souce diretory to target directory and sync with the backup disk

date >> $LOG
echo >> $LOG
tar -v -czpf $DIR_DEST$BKP_NAME $DIR_ORIG | tee -a $LOG
echo >> $LOG
rsync -av --delete $SDB1 $SDC1 | tee -a $LOG
#cp $DIR_DEST$BKP_NAME $DIR_DEST_2

# Umount volumes and put backup hard drives in wait
sync
umount $DIR_DEST $DIR_DEST_2
hdparm -S 24 /dev/sdb
hdparm -S 24 /dev/sdc
#Result message

echo >> $LOG
echo "Seu backup foi realizado com sucesso." | tee -a $LOG
echo >> $LOG
echo "Diretorio Copiado: ${DIR_ORIG}" | tee -a $LOG
echo >> $LOG
echo "Diretorio de Destino: ${DIR_DEST}${BKP_NAME}" | tee -a $LOG
echo >> $LOG
echo "Backup adicional: ${DIR_DEST_2}" | tee -a $LOG

#Shutdown the system after the backup.

#shutdown -h +1 O sistema ira desligar em 1 minuto...
echo >> $LOG
echo '##################################################' >> $LOG
echo >> $LOG
exit 0
