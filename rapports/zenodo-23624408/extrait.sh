#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/extrait.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/extraction.log 'cd ~/work/z23624408 && sh extrait.sh'
# Prérequis : pkg.zip dans le répertoire courant (voir telechargement.log). Aucun code du paquet n'est exécuté.
rm -rf pkg && mkdir pkg
python3 -I -c "import zipfile; zipfile.ZipFile('pkg.zip').extractall('pkg')"
echo "code extraction : $?"
md5sum pkg.zip
find pkg -type f | wc -l
find pkg -type f -size +0 -ls
