#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24218418/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24218418/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
F=polis_replication_v1.zip
B=https://zenodo.org/api/records/24218418/files
rm -rf work/z24218418 && mkdir -p work/z24218418/dl work/z24218418/pkg
cd work/z24218418/dl || exit 1
curl -sS -f --retry 3 -m 300 -o "$F" "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "0e2d6e97d5a1a85a5c3ce19804c1c3ad  $F" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "../dl/$F"
echo "code extraction : $?"
find . -type f | wc -l
find . -type f
