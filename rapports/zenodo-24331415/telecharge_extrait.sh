#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24331415/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24331415/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive de la fiche Zenodo 24331415, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
B=https://zenodo.org/api/records/24331415/files
rm -rf work/z24331415 && mkdir -p work/z24331415/dl work/z24331415/pkg
cd work/z24331415/dl || exit 1
curl -sS -f --retry 3 -m 300 -o pkg.zip "$B/lyapunov-maxplus-certification-v1.0.0.zip/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "bf9a0516262abde3c7cfa18069c51ba7  pkg.zip" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" ../dl/pkg.zip
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 3 -not -path './*/results/*' -not -path './*/feeders/*'
