#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "ERREUR ERREUR ERREUR ERREUR"
    echo "Le nombre de paramètres est incorrect. Paramètres attendus : 3"
    echo "ERREUR ERREUR ERREUR ERREUR"
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


value=$(rsync -avz --password-file=$password_file $chemin_source $chemin_cible --itemize-changes --out-format="%n" | awk '/\/$/ {print substr($0, 1, length($0)-1)}')

for dossier in $value
do
    chown -R wildfly: $chemin_cible/$dossier
    chmod -R 700 $chemin_cible/$dossier
done