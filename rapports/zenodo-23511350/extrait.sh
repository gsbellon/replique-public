#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23511350/extrait.sh sd-92569:work/z23511350/
#   bin/capture.sh rapports/zenodo-23511350/extraction.log 'cd ~/work/z23511350 && sh extrait.sh'
# Prérequis : DFAR.zip dans le répertoire courant (voir telechargement.log). Aucun code du paquet n'est exécuté.
rm -rf pkg && mkdir pkg
python3 -I -c "import zipfile; zipfile.ZipFile('DFAR.zip').extractall('pkg')"
echo "code extraction : $?"
md5sum DFAR.zip
find pkg -type f | wc -l
