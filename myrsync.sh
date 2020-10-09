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

contenuDIR1=$(find "$DIR1") #on recupere l'arborescence du premier repertoire
contenuDIR2=$(find "$DIR2") #on recupere l'arborescence du second repertoire

regex1="s/^$DIR1/$DIR2/g"   #on cree une regex pour tester l'existence des fichiers et repertoires dans le repertoire 2
regex2="s/^$DIR2/$DIR1/g"   #on cree une regex pour tester l'existence des fichiers et repertoires dans le repertoire 1


#La fonction ne renvoie rien
#La fonction prend en parametre le resultat de la commande find et une regex
#La fonction regarde l'existence des fichiers et repertoire d'un dossier 1 vers un dossier 2
#Par exemple si l'on appelle le script avec le repertoire a et b on aura cette arborescence de a :
#	a
#	a/c
#	a/d
#	a/d/e
#	a/d/f
#
#On change tous les a en b et on teste si le chemin existe, on va donc tester les chemins suivant :
#	b
#	b/c
#	b/d
#	b/d/e
#	b/d/f
#
#Et inversement

function parcours_repertoire() {
	for fileDirA in $1						  #On parcourt l'arborescence de a 
	do
		fileDirB=$(sed -e "$2" <<< "$fileDirA")
		if [ -d "$fileDirA" ] && [ ! -d "$fileDirB" ] 		  #Si c'est un repertoire dans a mais qu'il n'existe pas dans b
		then
			mkdir -p "$fileDirB"               		  #Alors on cree le repertoire dans b
		elif [ -f "$fileDirA" ]					  #Si c'est un fichier dans a
		then
			if [ ! -f "$fileDirB" ]	                          #Si il n'existe pas dans b
			then
				cp "$fileDirA" "$fileDirB"		  #Alors on cree le fichier dans b	
			elif [ -f "$fileDirB" ]				  #Si le fichier existe dans b
			then
				if [ "$fileDirB" -ot "$fileDirA" ]        #Si le fichier dans a est plus recent
				then
					rm "$fileDirB"                    #On supprime le fichier dans b
					cp "$fileDirA" "$fileDirB"        #On copier le fichier a dans b
				else					  #Sinon
					rm "$fileDirA"                    #On supprime le fichier dans a
					cp "$fileDirB" "$fileDirA"        #On copier le fichier b dans a
				fi
			fi
		fi
	done
}

parcours_repertoire "$contenuDIR1" "$regex1"
parcours_repertoire "$contenuDIR2" "$regex2"
