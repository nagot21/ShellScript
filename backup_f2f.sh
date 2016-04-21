#!/bin/bash
#
#Folder to folder backup script.
#Wrote by Ian Nagot in 01-26-11
#
#
#Script Configurations
#Where, DIR_ORIG is the backup diretory and DIR_DEST is where the compacted
#files will be put on. BKP_NAME is the name of the compacted file.

DIR_ORIG="/home/nagot/Music/"
#DIR_ORIG="cd /home/nagot/Music *"
DIR_DEST="/teste_backup/"
BKP_NAME=bkp_`date +%d-%m-%y`.tgz

#Compression of souce diretory directly on the distination directory

tar -czpf ${DIR_DEST}${BKP_NAME} ${DIR_ORIG}

#Result message

echo "Seu backup foi realizado com sucesso."
echo "Diretorio: ${DIR_ORIG}";
echo "Destino: ${DIR_DEST}${BKP_NAME}";
exit 0
