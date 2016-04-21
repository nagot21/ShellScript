#!/bin/bash

# BOF

### Begining of Variable Area ###

#DIR_DEST="/home/nagot/Desktop/n2_osmany"
DIR_DEST="$HOME/n2_osmany"
NICE="nice -n -20"
DEVICE=$1
LOG="$DIR_DEST/log.txt"

### End of Variable Area ###

### Begining of Command area ###

if [ ! -d $HOME/n2_osmany ]; then
	mkdir $HOME/n2_osmany
else
	echo "ja existe"
fi

clear
touch $LOG
echo -e "==========================\n" >> $LOG
echo `date` >> $LOG

copy_dev() {

echo -e "\nFazendo copia do dispositivo $DEVICE...\n" >> $LOG
echo -e "\n\033[1;34mFazendo copia do dispositivo $DEVICE...\033[0m\n"
$NICE dcfldd if=/dev/$DEVICE of=$DIR_DEST/pendrive_img_n2.img hash=md5,sha1 hashlog=$DIR_DEST/pendrive_img_n2.hash | tee -a $LOG
echo -e "\nCopia da Imagem concluida!" | tee -a $LOG
echo -e "\nTirando md5 do dispositivo localizado em /dev/$DEVICE..." | tee -a $LOG
$NICE md5sum /dev/$DEVICE > $DIR_DEST/pendrive_dev_n2.hash | tee -a $LOG
echo -e "\nTirando sha1 do dispositivo localizado em /dev/$DEVICE..." | tee -a $LOG
$NICE sha1sum /dev/$DEVICE >> $DIR_DEST/pendrive_dev_n2.hash | tee -a $LOG
#chown nagot:nagot $DIR_DEST/*

}

copy_dev

VAR1=$(head -n 1 $DIR_DEST/pendrive_img_n2.hash | cut -d " " -f 3)
VAR2=$(head -n 1 $DIR_DEST/pendrive_dev_n2.hash | cut -d " " -f 1)
VAR3=$(tail -n 1 $DIR_DEST/pendrive_img_n2.hash | cut -d " " -f 3)
VAR4=$(tail -n 1 $DIR_DEST/pendrive_dev_n2.hash | cut -d " " -f 1)

if [ $VAR1 != $VAR2 ] | [ $VAR3 != $VAR4 ]; then
	echo -e "\nHash md5 tirado pelo dcfldd:   $VAR1" >> $LOG
	echo -e "\nHash sha1 tirado pelo dcfldd:  $VAR3" >> $LOG
	echo -e "\nHash md5 tirado pelo md5sum:   $VAR2" >> $LOG
	echo -e "\nHash sha1 tirado pelo sha1sum: $VAR4" >> $LOG
	echo -e "\nOs hashs tirados pelo dcfldd e md5sum e sha1sum nao batem. REFAZENDO O PROCEDIMENTO!" >> $LOG
	echo -e "\nHash md5 tirado pelo dcfldd:   \033[7;33m$VAR1\033[0m"
	echo -e "\nHash sha1 tirado pelo dcfldd:  \033[7;33m$VAR3\033[0m"
	echo -e "\nHash md5 tirado pelo md5sum:   \033[7;33m$VAR2\033[0m"
	echo -e "\nHash sha1 tirado pelo sha1sum: \033[7;33m$VAR4\033[0m"
	echo -e "\n\033[1;31mOs hashs tirados pelo dcfldd e md5sum e sha1sum nao batem. REFAZENDO O PROCEDIMENTO!\033[0m" 
	$NICE rm -rf $DIR_DEST/*
	copy_dev
else
	echo -e "\nHash md5 tirado pelo dcfldd:   $VAR1" >> $LOG
	echo -e "\nHash md5 tirado pelo md5sum:   $VAR2" >> $LOG
	echo -e "\nHash sha1 tirado pelo dcfldd:  $VAR3" >> $LOG
	echo -e "\nHash sha1 tirado pelo sha1sum: $VAR4" >> $LOG
	echo -e "\nCopia efetuada com sucesso. FAZENDO A COPIA DA IMAGEM ORIGINAL!\n" >> $LOG
	echo -e "\nHash md5 tirado pelo dcfldd:   \033[7;33m$VAR1\033[0m"
	echo -e "\nHash md5 tirado pelo md5sum:   \033[7;33m$VAR2\033[0m"
	echo -e "\nHash sha1 tirado pelo dcfldd:  \033[7;33m$VAR3\033[0m"
	echo -e "\nHash sha1 tirado pelo sha1sum: \033[7;33m$VAR4\033[0m"
	echo -e "\n\033[1;34mCopia efetuada com sucesso. FAZENDO A COPIA DA IMAGEM ORIGINAL!\033[0m\n"
	$NICE cp -av $DIR_DEST/pendrive_img_n2.img $DIR_DEST/img_for_work_osmany_pen_n2.img | tee -a $LOG
	touch $DIR_DEST/copia.hash
#	chown nagot:nagot $DIR_DEST/*
	echo -e "\nTirando hash md5 da copia da imagem..." | tee -a $LOG
	$NICE md5sum $DIR_DEST/img_for_work_osmany_pen_n2.img >> $DIR_DEST/copia.hash
	echo -e "\nTirando hash sha1 da copia da imagem..." | tee -a $LOG
	$NICE sha1sum $DIR_DEST/img_for_work_osmany_pen_n2.img >> $DIR_DEST/copia.hash
	VAR5=$(head -n 1 $DIR_DEST/copia.hash | cut -d " " -f 1)
	VAR6=$(tail -n 1 $DIR_DEST/copia.hash | cut -d " " -f 1)
	echo -e "\nHash md5 tirado da imagem original pelo md5sum:   		$VAR2" >> $LOG
	echo -e "\nHash md5 tirado pelo md5sum da copia: 	     		$VAR5" >> $LOG
	echo -e "\nHash sha1 tirado da imagem original pelo sha1sum: 		$VAR4" >> $LOG
	echo -e "\nHash sha1 tirado pelo sha1sum da copia: 	     		$VAR6" >> $LOG
	echo -e "\nPrograma executado com sucesso!\n" >> $LOG
	echo -e "\nHash md5 tirado da imagem original pelo md5sum:   		\033[7;33m$VAR2\033[0m"
	echo -e "\nHash md5 tirado pelo md5sum da copia: 		     		\033[7;33m$VAR5\033[0m"
	echo -e "\nHash sha1 tirado da imagem original pelo sha1sum: 		\033[7;33m$VAR4\033[0m"
	echo -e "\nHash sha1 tirado pelo sha1sum da copia: 	     		\033[7;33m$VAR6\033[0m"
	echo -e "\n\033[1;34mPrograma executado com sucesso!\033[0m\n"
fi

### End of Command area ###

# EOF
