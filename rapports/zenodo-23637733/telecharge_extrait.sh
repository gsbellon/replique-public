#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23637733/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
F=replication_package.zip
B=https://zenodo.org/api/records/23637733/files
rm -rf work/z23637733 && mkdir -p work/z23637733/dl work/z23637733/pkg
cd work/z23637733/dl || exit 1
curl -sS -f --retry 3 -m 300 -o "$F" "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "ed8a12a4c567fef963cca925418ea5e5  $F" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "../dl/$F"
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3 -type f -size -200k
