#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/telecharge_trace.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/telechargement_trace.log 'cd ~/work/z23758240 && sh telecharge_trace.sh'
# Le README du paquet demande : git clone --depth 1 https://github.com/deib-polimi/RAS.git ; cp RAS/generators/wiki.1190153705.csv data/wiki.csv
# Même fichier, mêmes dépôt et chemin, récupéré par curl seul (aucun code du dépôt RAS n'est exécuté ni conservé).
mkdir -p trace
curl -sS -f -L --retry 3 -m 300 -o trace/wiki.csv https://raw.githubusercontent.com/deib-polimi/RAS/HEAD/generators/wiki.1190153705.csv
echo "code curl : $?"
ls -l trace/wiki.csv
sha256sum trace/wiki.csv
wc -l trace/wiki.csv
head -n 3 trace/wiki.csv
