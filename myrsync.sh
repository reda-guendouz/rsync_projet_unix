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
	if [ -d $contDIR1 ] && [ ! -d $testContDIR2 ]
	then
		mkdir -p $testContDIR2
	elif [ -f $contDIR1 ]
	then
		if [ ! -f $testContDIR2 ]
		then
			cp $contDIR1 $testContDIR2
		elif [ -f $testContDIR2 ]
		then
			if [ $testContDIR2 -ot $contDIR1 ]
			then
				rm $testContDIR2
				cp $contDIR1 $testContDIR2
			elif [ ! $testContDIR2 -ot $contDIR1 ]
			then
				rm $contDIR1
				cp $testContDIR2 $contDIR1
			fi
		fi
	fi
done

for contDIR2 in $contenuDIR2
do
	testContDIR1=$(sed -e "$regex2" <<< $contDIR2)
	if [ -d $contDIR2 ] && [ ! -d $testContDIR1 ]
	then
		mkdir -p $testContDIR1
	elif [ -f $contDIR2 ]
	then
		if [ ! -f $testContDIR1 ]
		then
			cp $contDIR2 $testContDIR1
		elif [ -f $testContDIR1 ]
		then
			if [ $testContDIR1 -ot $contDIR2 ]
			then
				rm $testContDIR1
				cp $contDIR2 $testContDIR1
			elif [ ! $testContDIR1 -ot $contDIR2 ]
			then
				rm $contDIR2
				cp $testContDIR1 $contDIR2
			fi
		fi
	fi
done
