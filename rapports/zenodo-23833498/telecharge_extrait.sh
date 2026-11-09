#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23833498/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23833498/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (recherche.json de rapports/zenodo-recherche-20261102), extrait dans un dossier vide pkg/ avec python -I
# (aucun code du paquet n'est exécuté).
F=replication_package.zip
B=https://zenodo.org/api/records/23833498/files
rm -rf work/z23833498 && mkdir -p work/z23833498/dl work/z23833498/pkg
cd work/z23833498/dl || exit 1
curl -sS -f --retry 3 -m 300 -o "$F" "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "65a259b6b6ccba56a898ffafb1ada7a6  $F" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "../dl/$F"
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3 -type f -size -200k
