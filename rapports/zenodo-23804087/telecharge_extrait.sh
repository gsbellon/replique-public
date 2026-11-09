#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23804087/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23804087/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) replication-package_JSS.zip depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
B=https://zenodo.org/api/records/23804087/files
rm -rf work/z23804087 && mkdir -p work/z23804087/dl work/z23804087/pkg
cd work/z23804087/dl || exit 1
curl -sS -f --retry 3 -m 300 -o replication-package_JSS.zip "$B/replication-package_JSS.zip/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "627c352028b0f6263f9f72882ec4ddc8  replication-package_JSS.zip" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" ../dl/replication-package_JSS.zip
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3
