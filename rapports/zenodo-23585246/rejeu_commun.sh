#!/bin/sh
# Rejeu de la comparaison par le comparateur commun CSV (article 5 bis, tâche 3 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_csv.py rapports/zenodo-23585246/rejeu_commun.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/rejeu_commun.log 'cd ~/work/z23585246 && sh rejeu_commun.sh'
# Livré : pkg/…/output/tables ; régénéré : run/output/tables. Chaque CSV est comparé en égalité exacte puis à
# rtol 1e-6 / atol 1e-12 ; la dernière ligne du comparateur (RESULTAT) est reportée, le détail se relance fichier par fichier.
# Rien n'est modifié ; aucun code du paquet n'est exécuté.
cd ~/work/z23585246
P=pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/output/tables
R=run/output/tables
ex=0; tol=0; n=0
for f in $(ls $P); do
  n=$((n+1))
  a=$(python3 -I compare_csv.py $P/$f $R/$f | tail -n 1)
  b=$(python3 -I compare_csv.py --rtol 1e-6 --atol 1e-12 $P/$f $R/$f | tail -n 1)
  echo "$f | exact : $a | rtol 1e-6 : $b"
  case "$a" in "RESULTAT: identique"*) ex=$((ex+1));; esac
  case "$b" in "RESULTAT: identique"*) tol=$((tol+1));; esac
done
echo "TOTAL fichiers=$n identiques_exact=$ex identiques_rtol1e-6=$tol"
