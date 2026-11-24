#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24317267/extrait.sh sd-92569:work/extrait_24317267.sh
#   bin/capture.sh rapports/zenodo-24317267/extrait.log 'sh work/extrait_24317267.sh'
# Extrait l'archive (module zipfile de python, mode isolé) dans pkg/ (original, jamais monté en écriture), garde le
# zip intact, puis convertit README.pdf en texte (pdftotext) pour lecture. Rien du paquet n'est exécuté.
cd work/z24317267 || exit 1
rm -rf pkg && mkdir pkg
python3 -I -m zipfile -e package.zip pkg
ls pkg
pdftotext -layout pkg/README.pdf README.txt
wc -l README.txt
