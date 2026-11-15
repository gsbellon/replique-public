#!/bin/sh
# Rejeu de la comparaison par le comparateur commun (article 5 bis, tâche 2 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_csv.py rapports/zenodo-23673342/rejeu_commun.sh sd-92569:work/z23673342/
#   bin/capture.sh rapports/zenodo-23673342/rejeu_commun.log 'cd ~/work/z23673342 && sh rejeu_commun.sh'
# Pour chaque CSV fourni (pkg/output) : comparaison à son homologue régénéré (run_full/output), rtol 1e-9, atol 1e-12.
# Les CSV non réécrits par run_all.R sont signalés ABSENT du côté régénéré seulement s'ils n'existent pas dans run_full.
# Aucun code du paquet n'est exécuté.
cd ~/work/z23673342
ok=0; ko=0; abs=0
for f in $(cd pkg/output && find . -type f -name '*.csv' | sort); do
  if [ ! -f "run_full/output/$f" ]; then echo "ABSENT $f"; abs=$((abs+1)); continue; fi
  res=$(python3 -I compare_csv.py --rtol 1e-9 --atol 1e-12 "pkg/output/$f" "run_full/output/$f" | tail -n 1)
  echo "$f : $res"
  case "$res" in
    "RESULTAT: identique"*) ok=$((ok+1));;
    *) ko=$((ko+1));;
  esac
done
echo "TOTAL identiques=$ok differents=$ko absents=$abs"
