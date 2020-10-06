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
		DIR1=$1
		DIR2=$2
		echo "tout est bon"
	fi
fi
