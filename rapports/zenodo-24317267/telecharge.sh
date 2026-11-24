#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24317267/telecharge.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24317267/telechargement.log 'sh work/telecharge.sh'
# Télécharge sur l'hôte (curl seulement) l'archive de la fiche 24317267, vérifie son MD5 (fiche_zenodo.json),
# en liste le contenu (unzip -l). Rien du paquet n'est extrait ni exécuté ici.
rm -rf work/z24317267 && mkdir -p work/z24317267
cd work/z24317267 || exit 1
echo "57f0c892a8049b7c9f53863d22c010bb  package.zip" > MD5.txt
curl -sS -f --retry 3 -m 300 -o package.zip "https://zenodo.org/api/records/24317267/files/Replication%20package.zip/content" || { echo "ECHEC curl : $?"; exit 1; }
md5sum -c MD5.txt
ls -l
unzip -l package.zip
