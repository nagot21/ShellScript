#!/bin/bash

INPUT="/tmp/frases.txt"
AUX=$RANDOM
NUM=`wc -l $INPUT | cut -d " " -f 1`

while [ $AUX -gt $NUM ]; do	
	AUX=$RANDOM
done

FRASE=$(sed "$AUX!d" $INPUT)

echo $FRASE
