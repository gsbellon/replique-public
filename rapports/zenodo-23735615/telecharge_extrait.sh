#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23735615/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23735615/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) l'archive depuis Zenodo, vérifie le MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
F=shiguangzhe666/llm-test-generation-quarantine-v1.0.0.zip
B=https://zenodo.org/api/records/23735615/files
rm -rf work/z23735615 && mkdir -p work/z23735615/dl work/z23735615/pkg
cd work/z23735615/dl || exit 1
curl -sS -f --retry 3 -m 300 -o pkg.zip "$B/$F/content" || { echo "ECHEC curl : $?"; exit 1; }
echo "81d27bdae77cb3d22f8f36fc87f7275c  pkg.zip" > MD5.txt
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../pkg || exit 1
python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" ../dl/pkg.zip
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 2 | head -60
