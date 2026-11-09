#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23673342/compare_output.py rapports/zenodo-23673342/lance_compare.sh sd-92569:work/z23673342/
#   bin/capture.sh rapports/zenodo-23673342/comparaison_agg.log 'cd ~/work/z23673342 && sh lance_compare.sh run_agg2'
#   bin/capture.sh rapports/zenodo-23673342/comparaison_full.log 'cd ~/work/z23673342 && sh lance_compare.sh run_full'
# Compare output/ fourni (pkg/output) à <dossier>/output régénéré.
python3 -I compare_output.py pkg/output "$1/output"
