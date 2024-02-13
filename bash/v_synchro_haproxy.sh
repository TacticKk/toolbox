#!/bin/bash

echo "Début du script - $(date "+%d/%m/%Y %H:%M:%S")"

#-- Le script ne doit être lancé que sur SERVER

if [[ $(uname -n |  cut -d'.' -f1) != SERVER ]]; then
    echo "Erreur : Le script doit être lance sur SERVEUR (et non $(uname -n |  cut -d'.' -f1))"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Le service HAProxy du SERVEUR doit être UP
sudo systemctl is-active haproxy
if [[ $? -ne 0 ]]; then
    echo "Erreur : Le service HAProxy n'est pas up sur SERVEUR. Veuillez vérifier la raison et relancer e script."
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Synchronisation de /etc/haproxy/

echo "Info - $(date +"%Y/%m/%d %H:%M:%S") - Synchronisation du dossier /etc/haproxy/"

sudo scp -rp /etc/haproxy/ SERVEUR2:/etc/haproxy
if [[ $? -ne 0 ]]; then
    echo "Erreur : Echec de la synchronisation - Dossier introuvable"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi
sudo ssh SERVEUR2 'haproxy -c -f /etc/haproxy/haproxy.cfg'

if [[ $? -eq 0 ]]; then
    echo "OK : Synchronisation du dossier /etc/haproxy terminee"
    echo "OK : Fichier de configuration HAProxy valide"
else
    echo "Erreur : Echec de la synchronisation du dossier /etc/haproxy/"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Reload du service HAProxy

echo "Info - $(date +"%Y/%m/%d %H:%M:%S") - Reload du service HAProxy"

sudo ssh SERVEUR2 'systemctl reload haproxy'
if [[ $? -eq 0 ]]; then
    echo "OK : Reload du service HAProxy termine sans erreurs"
    echo "OK : Script termine sans erreurs"
    exit 0
else
    echo "Erreur : Echec de la synchronisation du dossier /etc/haproxy/"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi
