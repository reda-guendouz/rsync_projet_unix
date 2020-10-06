#!/bin/bash

#Test des arguements donné en parametres

if [ $# -ne 2 ]
then
	echo "ERROR: Pas le bon nombre d'argument"
	exit 1 #code erreur pour un mauvais nombre d'argument
else
	if [ ! -d $1 ] || [ ! -d $2 ]
	then
		echo "ERROR: Un des arguments n'est pas un repertoire"
		exit 2 #code erreur si arguments n'est pas un repertoire
	else
		DIR1=$(sed -e 's/\/$//g' <<< $1)
		DIR2=$(sed -e 's/\/$//g' <<< $2)
	fi
fi

#Parcours de repertoire

contenuDIR1=`find $DIR1`
contenuDIR2=`find $DIR2` 

regex="s/^$DIR1/$DIR2/g"

#Liste de repertoire transfert

for contDIR1 in $contenuDIR1
do
	testContDIR2=$(sed -e "$regex" <<< $contDIR1)
	if [ -f $testContDIR2 ] || [ -d $testContDIR2 ]
	then
		echo "$contDIR1 et $testContDIR2"
		#verif date de modif
	fi
done
