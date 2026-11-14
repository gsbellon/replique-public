#!/bin/sh
# Rejeu de la comparaison par le comparateur commun (article 5 bis, tâche 2 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_csv.py rapports/zenodo-23624408/rejeu_commun.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/rejeu_commun.log 'cd ~/work/z23624408 && sh rejeu_commun.sh'
# Pour chaque CSV fourni (pkg/output) : comparaison à son homologue régénéré (out), tolérances rtol 1e-9, atol 1e-12.
# Aucun code du paquet n'est exécuté.
cd ~/work/z23624408
ok=0; ko=0; abs=0
for f in $(cd pkg/output && find . -type f -name '*.csv' | sort); do
  if [ ! -f "out/$f" ]; then echo "ABSENT $f"; abs=$((abs+1)); continue; fi
  res=$(python3 -I compare_csv.py --rtol 1e-9 --atol 1e-12 "pkg/output/$f" "out/$f" | tail -n 1)
  echo "$f : $res"
  case "$res" in
    "RESULTAT: identique"*) ok=$((ok+1));;
    *) ko=$((ko+1));;
  esac
done
echo "TOTAL identiques=$ok differents=$ko absents=$abs"
