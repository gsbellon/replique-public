#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24353093/telecharge_lecture.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24353093/telechargement_lecture.log 'sh work/telecharge_lecture.sh'
# Télécharge sur l'hôte (curl seulement) README.md et run_wchn.py de la fiche 24353093, vérifie leur MD5 (fiche_zenodo.json).
# Rien du paquet n'est exécuté.
B=https://zenodo.org/api/records/24353093/files
rm -rf work/z24353093 && mkdir -p work/z24353093/lecture
cd work/z24353093/lecture || exit 1
curl -sS -f --retry 3 -m 120 -o README.md "$B/README.md/content" || { echo "ECHEC curl README : $?"; exit 1; }
curl -sS -f --retry 3 -m 120 -o run_wchn.py "$B/run_wchn.py/content" || { echo "ECHEC curl run_wchn : $?"; exit 1; }
echo "a9ecdf66d17e5b7ec6c9519d817461d0  README.md" > MD5.txt
echo "a213c6898fe2cb6ca29ddf0e77661dc9  run_wchn.py" >> MD5.txt
md5sum -c MD5.txt
