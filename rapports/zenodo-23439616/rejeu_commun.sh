#!/bin/sh
# Rejeu de la comparaison par le comparateur commun JSON (article 5 bis, tâche 2 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-23439616/rejeu_commun.sh sd-92569:work/z23439616/
#   bin/capture.sh rapports/zenodo-23439616/rejeu_commun.log 'cd ~/work/z23439616 && sh rejeu_commun.sh'
# Référence : pristine_code/ (JSON fournis, copiés avant exécution) ; obtenus : run, run2, run3, run4 (code/).
# Égalité exacte (tolérances par défaut 0 et 0) : rien n'est ignoré. Aucun code du paquet n'est exécuté.
cd ~/work/z23439616
ok=0; ko=0
for r in run run2 run3 run4; do
  for f in study geometry graded; do
    echo "== $r results_cnsns_$f.json"
    python3 -I compare_json.py pristine_code/results_cnsns_$f.json $r/code/results_cnsns_$f.json
    case $? in 0) ok=$((ok+1));; *) ko=$((ko+1));; esac
  done
done
echo "TOTAL identiques=$ok differents=$ko"
