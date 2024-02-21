#!/bin/bash

##  Programme    : v_rsync_synchro.sh
##  Auteur       : BOURDAREL Antoine (TME Solutec)
##  Date         : 21/02/2024
##
##  Description  : Copie des fichiers d'un serveur windows à un serveur linux
##
##  Paramètres   : aucun
##
##  Retour       : 1 en cas d'erreur
##                 0 sinon
##                 8 paramètres incorrect
##
##  Modifications ulterieures :
## Date        Par                             Objet
## ----------- ------------------------------- ----------------------------------------------------------------------------------
##
##
##

#--
#-- Verifications
#--

if [[ $# -ne 3 ]]; then
    print "ERREUR ERREUR ERREUR ERREUR"
    print "Le nombre de paramètres est incorrect. Paramètres attendus : 3"
    print "ERREUR ERREUR ERREUR ERREUR"
    exit 8
fi

chemin_source=$1
chemin_cible=$2
password_file=$3

echo "===================="
echo "Chemin source : $chemin_source"
echo "Chemin cible : $chemin_cible"
echo "password : $password_file"
echo "===================="


rsync -avz --password-file=$password_file $chemin_source $chemin_cible