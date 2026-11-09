#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/diag_cellule.py rapports/zenodo-23758240/lance_diag_cellule.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/diag_cellule.log 'cd ~/work/z23758240 && sh lance_diag_cellule.sh'
python3 -I diag_cellule.py pkg/autoscaling-sensitivity-study/results run/results
