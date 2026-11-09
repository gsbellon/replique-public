#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23673342/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23673342/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (rapports/zenodo-recherche-20261105/recherche.json), extrait dans un dossier vide pkg/ avec python -I
# (aucun code du paquet n'est exécuté).
F=BOD-fixed-MPI_v1.0.0_artigo_v4.zip
B=https://zenodo.org/api/records/23673342/files
rm -rf work/z23673342 && mkdir -p work/z23673342/dl work/z23673342/pkg
cd work/z23673342/dl || exit 1
curl -sS -f --retry 3 -m 300 -o "$F" "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "56956a46212e4d279671c48c11399144  $F" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "../dl/$F"
echo "code extraction : $?"
find . -type f | wc -l
find . -type f
