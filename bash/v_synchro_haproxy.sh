#!/bin/bash

echo "Début du script - $(date "+%d/%m/%Y %H:%M:%S")"

#-- Le script ne doit être lancé que sur l-i-fa-p01-he

if [[ $(uname -n |  cut -d'.' -f1) != L-INF-HA-P01-HE ]]; then
    echo "Erreur : Le script doit être lance sur L-INF-H-RP01-HE (et non $(uname -n |  cut -d'.' -f1))"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Le script ne doit pas avoir de param▒tre(s)
if [[ $# -ne 0 ]]; then
    echo "Erreur : Le script ne doit pas contenir de paramètre(s)"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Le service HAProxy du L-INF-HA-P01-HE doit être UP
sudo systemctl is-active haproxy
if [[ $? -ne 0 ]]; then
    echo "Erreur : Le service HAProxy n'est pas up sur le L-INF-HA-P01-HE. Veuillez vérifier la raison et relancer e script."
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi

#-- Synchronisation de /etc/haproxy/

echo "Info - $(date +"%Y/%m/%d %H:%M:%S") - Synchronisation du dossier /etc/haproxy/"

rsync --verbose --archive --hard-links --recursive --delete /etc/haproxy/ l-inf-ha-p02-he:/etc/haproxy
if [[ $? -ne 0 ]]; then
    echo "Erreur : Echec de la synchronisation - Dossier introuvable"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi
sudo ssh L-INF-HA-P02-HE 'haproxy -c -f /etc/haproxy/haproxy.cfg'

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

sudo ssh L-INF-HA-P02-HE 'systemctl reload haproxy'
if [[ $? -eq 0 ]]; then
    echo "OK : Reload du service HAProxy termine sans erreurs"
    echo "OK : Script termine sans erreurs"
    exit 0
else
    echo "Erreur : Echec de la synchronisation du dossier /etc/haproxy/"
    echo "Erreur - $(date "+%d/%m/%Y %H:%M:%S") - Erreur"
    exit 1
fi
