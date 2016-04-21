#!/bin/bash

# BOF

MES=`date | cut -f 2 -d " "`
ANO=`date | cut -f 7 -d " "`
ORIGEM="/home/torrents/Adulto"
ORIGEM2="/home/IanCopilation"
#ORIGEM="/home/teste"
#ORIGEM2="/home/teste2"
DESTINO="/backup"
BKP_NAME1=bkp_incremental_adulto_`date +%d-%m-%y`
BKP_NAME2=bkp_incremental_iancopilation_`date +%d-%m-%y`
TIME=$(date +"%d-%m-%Y")
#LOG="$DESTINO/backup.log"
LOGLINK="$DESTINO/backup.log"
LOG="/var/log/backup.log"
MOUNT="/usr/local/sbin/mount-all"
UMOUNT="/usr/local/sbin/umount-all"

# Funcao checa e cria a estrutura de pastas

cria_pasta() {

if [ -d $DESTINO/$ANO ]; then

	echo "pasta ja existe"

else

	echo "pasta nao existe. criando..."
	mkdir $DESTINO/$ANO

fi

if [ -d $DESTINO/$ANO/$MES ]; then

	echo "pasta ja existe"

else

	echo "pasta nao existe. criando..."
	mkdir $DESTINO/$ANO/$MES

fi

}

# Funcao cria o backup full das duas pastas de origem

backup_full() {

rm -rf $LOGLINK

date >> $LOG
echo -e "\n" >> $LOG
echo -e "Criando Backup Full da pasta $ORIGEM.\n" >> $LOG
echo -e "Criando Backup na pasta $DESTINO.\n" >> $LOG

nice -n -20 rsync -av --delete $ORIGEM $DESTINO/$ANO/backup_full_adulto-$TIME >> $LOG
#ln -sv $DESTINO/$ANO/backup_full_adulto-$TIME/teste $DESTINO/current_adulto >> $LOG
#ln -sv $DESTINO/$ANO/backup_full_adulto-$TIME/teste $DESTINO/full_adulto >> $LOG
ln -sv $DESTINO/$ANO/backup_full_adulto-$TIME/Adulto $DESTINO/current_adulto >> $LOG
ln -sv $DESTINO/$ANO/backup_full_adulto-$TIME/Adulto $DESTINO/full_adulto >> $LOG

echo -e "\n" >> $LOG

echo -e "######################## FIM DO BACKUP DA PASTA $ORIGEM #########################\n" >> $LOG

echo -e "Criando Backup Full da pasta $ORIGEM2.\n" >> $LOG

echo -e "Criando Backup na pasta $DESTINO.\n" >> $LOG

nice -n -20 rsync -av --delete $ORIGEM2 $DESTINO/$ANO/backup_full_iancopilation-$TIME >> $LOG
#ln -sv $DESTINO/$ANO/backup_full_iancopilation-$TIME/teste2 $DESTINO/current_iancopilation >> $LOG
#ln -sv $DESTINO/$ANO/backup_full_iancopilation-$TIME/teste2 $DESTINO/full_iancopilation >> $LOG
ln -sv $DESTINO/$ANO/backup_full_iancopilation-$TIME/IanCopilation $DESTINO/current_iancopilation >> $LOG
ln -sv $DESTINO/$ANO/backup_full_iancopilation-$TIME/IanCopilation $DESTINO/full_iancopilation >> $LOG

echo -e "\n" >> $LOG

echo -e "######################## FIM DO BACKUP DA PASTA $ORIGEM2 #########################\n" >> $LOG

ln -sv $LOG $LOGLINK

}

# Funcao cria o backup incremental

backup_incremental() {

if [ -d $DESTINO/full_adulto ] && [ -d $DESTINO/full_iancopilation ]; then

	rm -rf $LOGLINK

	date >> $LOG

	echo -e "\n" >> $LOG

	echo -e "INICIANDO BACKUP INCREMENTAL\n" >> $LOG

	echo -e "######################## Inicio do backup da pasta $ORIGEM #########################\n" >> $LOG

	nice -n -20 rsync -aWPv --delete --compare-dest=$DESTINO/full_adulto/ $ORIGEM/ $DESTINO/$ANO/$MES/$BKP_NAME1 >> $LOG
	rm -rf $DESTINO/current_adulto
 	ln -sv $DESTINO/$ANO/$MES/$BKP_NAME1 $DESTINO/current_adulto >> $LOG

	echo -e "\n" >> $LOG

	echo -e "######################## backup da pasta $ORIGEM realizado com sucesso #########################\n" >> $LOG

	echo -e "######################## Inicio do backup da pasta $ORIGEM2 #########################\n" >> $LOG

	nice -n -20 rsync -aWPv --delete --compare-dest=$DESTINO/full_iancopilation/ $ORIGEM2/ $DESTINO/$ANO/$MES/$BKP_NAME2 >> $LOG
	rm -rf $DESTINO/current_iancopilation
 	ln -sv $DESTINO/$ANO/$MES/$BKP_NAME2 $DESTINO/current_iancopilation >> $LOG

	echo -e "\n" >> $LOG

	echo -e "######################## backup da pasta $ORIGEM2 realizado com sucesso #########################\n" >> $LOG
else
 	echo -e "Crie pelo menos um backup completo!\n"

 	exit -1
fi

echo -e "Seu backup incremental foi realizado com sucesso.\n" >> $LOG
echo -e "Diretorios Copiados: $ORIGEM e $ORIGEM2 \n" >> $LOG
echo -e "Diretorio de Destino: $DESTINO \n" >> $LOG

date >> $LOG

echo -e "\n" >> $LOG
echo -e "######################## FIM DO BACKUP INCREMENTAL #########################\n" >> $LOG
echo >> $LOG

ln -sv $LOG $LOGLINK

}

# Monta os discos do servidor

mount() {

$MOUNT

}

umount () {

$UMOUNT

}

# Desliga o sistema

shutdown() {

shutdown -h +1 O sistema ira desligar em 1 minuto...

}

case $1 in

	-f )
	mount
	cria_pasta
	backup_full
	umount
	exit
	;;

	-i )
	mount
	cria_pasta
	backup_incremental
	umount
	exit
	;;
	
	-m )
	mount
	exit
	;;
	
	-s )
	shutdown
	exit
	;;

	-t )
	cria_pasta
	exit
	;;

	-u )
	umount
	exit
	;;

	*)
        echo "Use: $0 {-f for full backup | -i for incremental backup | -m to mount devices | -s to turn off the system | -t to create folder structure | -u to umount devices}"
esac

# EOF
