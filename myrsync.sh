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

regex1="s/^$DIR1/$DIR2/g"
regex2="s/^$DIR2/$DIR1/g"

#Liste de repertoire transfert

for contDIR1 in $contenuDIR1
do
	testContDIR2=$(sed -e "$regex1" <<< $contDIR1)
	if [ -f $testContDIR2 ] || [ -d $testContDIR2 ]
	then
		echo "$contDIR1 et $testContDIR2"
		if [ $contDIR1 -nt $testContDIR2 ]
		then
			rm -r $testContDIR2
			cp -r $contDIR1 $testContDIR2
		elif [ $contDIR1 -ot $testContDIR2 ]
		then
			rm -r $contDIR1
			cp -r $testContDIR2 $contDIR1
		fi
	else
		cp -r $contDIR1 $testContDIR2
	fi
done

for contDIR2 in $contenuDIR2
do
	testContDIR1=$(sed -e "$regex2" <<< $contDIR1)
	if [ -f $testContDIR1 ] || [ -d $testContDIR1 ]
	then
		echo "$contDIR2 et $testContDIR1"
		if [ $contDIR2 -nt $testContDIR1 ]
		then
			rm -r $testContDIR1
			cp -r $contDIR2 $testContDIR1
		elif [ $contDIR2 -ot $testContDIR1 ]
		then
			rm -r $contDIR2
			cp -r $testContDIR1 $contDIR2
		fi
	else
		cp -r $contDIR2 $testContDIR1
	fi
done
