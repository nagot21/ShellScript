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
DIR_DEST="/teste_backup/"
BKP_NAME=bkp_`date +%d-%m-%y`.tgz
DIR_DEST_2="/teste_backup2/"

#Compression of souce diretory directly on the distination directory

tar -czpf ${DIR_DEST}${BKP_NAME} ${DIR_ORIG}
cp ${DIR_DEST}${BKP_NAME} ${DIR_DEST_2}

#Result message

echo
echo
echo
echo "Seu backup foi realizado com sucesso."
echo
echo
echo "Diretorio: ${DIR_ORIG}";
echo
echo
echo "Destino: ${DIR_DEST}${BKP_NAME}";
echo
echo
echo "Copiando arquivo de backup para destino adicional: ${DIR_DEST_2}";
echo
echo

#Shutdown the system after the backup.

sync
shutdown -h +1 O sistema ira desligar em 1 minuto...
exit 0
