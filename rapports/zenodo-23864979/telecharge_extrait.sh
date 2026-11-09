#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23864979/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23864979/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
F=cost_dispersion_networks_replication_v4.0.zip
B=https://zenodo.org/api/records/23864979/files
rm -rf work/z23864979 && mkdir -p work/z23864979/dl work/z23864979/pkg
cd work/z23864979/dl || exit 1
curl -sS -f --retry 3 -m 300 -o "$F" "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "97467e28258140911e12a522e9b15f6f  $F" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "../dl/$F"
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3 -type f -size -200k
