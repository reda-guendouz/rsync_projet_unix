#!/bin/bash

#Test des arguements donné en parametres

if [ $# -ne 2 ]
then
	echo "ERROR: Pas le bon nombre d'argument"
	exit 1 #code erreur pour un mauvais nombre d'argument
else
	if [ ! -d "$1" ] || [ ! -d "$2" ]
	then
		echo "ERROR: Un des arguments n'est pas un repertoire"
		exit 2 #code erreur si arguments n'est pas un repertoire
	else
		DIR1=$(sed -e 's/\/$//g' <<< "$1")
		DIR2=$(sed -e 's/\/$//g' <<< "$2")
	fi
fi

#Parcours de repertoire

contenuDIR1=$(find "$DIR1")
contenuDIR2=$(find "$DIR2")

regex1="s/^$DIR1/$DIR2/g"
regex2="s/^$DIR2/$DIR1/g"


function parcours_repertoire() {
	for contDIR in $1
	do
		testContDIR=$(sed -e "$2" <<< "$contDIR")
		if [ -d "$contDIR" ] && [ ! -d "$testContDIR" ]
		then
			mkdir -p "$testContDIR"
		elif [ -f "$contDIR" ]
		then
			if [ ! -f "$testContDIR" ]
			then
				cp "$contDIR" "$testContDIR"
			elif [ -f "$testContDIR" ]
			then
				if [ "$testContDIR" -ot "$contDIR" ]
				then
					rm "$testContDIR"
					cp "$contDIR" "$testContDIR"
				elif [ ! "$testContDIR" -ot "$contDIR" ]
				then
					rm "$contDIR"
					cp "$testContDIR" "$contDIR"
				fi
			fi
		fi
	done
}

parcours_repertoire "$contenuDIR1" "$regex1"
parcours_repertoire "$contenuDIR2" "$regex2"
