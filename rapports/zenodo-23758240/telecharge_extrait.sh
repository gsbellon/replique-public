#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23758240/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) zenodo_code_package.zip depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
B=https://zenodo.org/api/records/23758240/files
rm -rf work/z23758240 && mkdir -p work/z23758240/dl work/z23758240/pkg
cd work/z23758240/dl || exit 1
curl -sS -f --retry 3 -m 300 -o zenodo_code_package.zip "$B/zenodo_code_package.zip/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "32edde13ba2cedcb3dccfb22befff830  zenodo_code_package.zip" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" ../dl/zenodo_code_package.zip
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3 -not -name '*.png' -not -name '*.pdf'
