#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/extrait.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/extraction.log 'cd ~/work/z23585246 && sh extrait.sh'
# Prérequis : OIL.zip dans le répertoire courant (voir telechargement.log). Aucun code du paquet n'est exécuté.
rm -rf pkg && mkdir pkg
python3 -I -c "import zipfile; zipfile.ZipFile('OIL.zip').extractall('pkg')"
echo "code extraction : $?"
md5sum OIL.zip
find pkg -type f | wc -l
find pkg -maxdepth 3
