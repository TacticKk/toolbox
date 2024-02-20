#!/bin/bash

##  Programme    : v_synchro_rsync.sh
##  Auteur       : BOURDAREL Antoine (TME Solutec)
##  Date         : 16/02/2024
##
##  Description  :  Synchronisation de fichiers via RSYNC
##
##  Paramètres   : 
##          1 - Chemin du répertoire source Windows (en notation Linux - ex: c/TEMP/temp pour C:\TEMP\temp)
##          2 - Chemin du répertoire cible Linux (en notation Linux - ex : /opt/gl/merco)
##          3 : Nom du serveur cible linux (nom complet du serveur - ex:l-grc-as-r01.grandlyon.fr)
##          4 : Compte de connexion au serveur linux
##          5 : Suppression du fichier source ('O' ou 'N')
##          6..n : Nom du répertoire à copier
##
##  Retour       : 
##          0       Fin normale de la copie des fichiers 
##          1       En cas d'erreur
##          2       Nombre de paramètres recus incorrect
##          3       Erreur dans la copie d'un fichier vers le repertoire cible
##
##  Modifications ulterieures :
## Date        Par                             Objet
## ----------- ------------------------------- ----------------------------------------------------------------------------------
##

# CONFIGURATION INITIALE
# [[ Vérification paramètres ]]

if [[ $# -ne 5 ]]; then
    print " Erreur - Nombre de paramètres incorrects"
    exit 2
fi

# [[ Mise en place des variables ]]
rep_source=$1
rep_cible=$2
srv_cible=$3
compte=$4
repertoire=$5
chemin_source="/cygdrive/$rep_source"

print "==> Parametre 1 : Nom du répertoire source"
print "                    $rep_source"
print "==> Parametre 2 : Nom du répertoire cible"
print "                    $rep_cible"
print "==> Parametre 3 : Nom du serveur cible"
print "                    $srv_cible"
print "==> Parametre 4 : Nom du compte"
print "                    $compte"
print "==> Parametre 5 : Nom du chemin source"
print "                    $chemin_source"
print

