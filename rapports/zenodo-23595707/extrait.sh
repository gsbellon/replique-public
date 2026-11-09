#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23595707/extrait.sh sd-92569:work/z23595707/
#   bin/capture.sh rapports/zenodo-23595707/extraction.log 'cd ~/work/z23595707 && sh extrait.sh'
# Prérequis : QS.zip dans le répertoire courant (voir telechargement.log). Aucun code du paquet n'est exécuté.
rm -rf pkg && mkdir pkg
python3 -I -c "import zipfile; zipfile.ZipFile('QS.zip').extractall('pkg')"
echo "code extraction : $?"
md5sum QS.zip
find pkg -type f | wc -l
find pkg -maxdepth 2
