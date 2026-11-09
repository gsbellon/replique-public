#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/compare_csv.py rapports/zenodo-23758240/lance_compare_csv.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/comparaison_csv.log 'cd ~/work/z23758240 && sh lance_compare_csv.sh'
python3 -I compare_csv.py pkg/autoscaling-sensitivity-study/results run/results
