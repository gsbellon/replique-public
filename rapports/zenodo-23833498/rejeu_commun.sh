#!/bin/sh
# Rejeu de la comparaison par les comparateurs communs (article 5 bis, tâche 3 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-23833498/rejeu_commun.sh sd-92569:work/z23833498/
#   bin/capture.sh rapports/zenodo-23833498/rejeu_commun.log 'cd ~/work/z23833498 && sh rejeu_commun.sh'
# Livré : pkg/ ; régénéré : run/. Aucun CSV dans ce paquet : les trois .json passent par bin/compare_json.py
# (égalité exacte, rien d'ignoré), les huit figures .png par cmp. Le scp écrase, sur l'exécuteur seulement, le
# compare_json.py propre au dossier (conservé dans le dépôt). Aucun code du paquet n'est exécuté.
cd ~/work/z23833498
ok=0; ko=0
for f in archetype_results.json extended_results.json robustness_results.json; do
  res=$(python3 -I compare_json.py "pkg/$f" "run/$f")
  echo "== $f (compare_json.py)"; echo "$res"
  case "$res" in *"RESULTAT: identique"*) ok=$((ok+1));; *) ko=$((ko+1));; esac
done
for n in 1 2 3 4 5 6 7 8; do
  f=figures/Figure_$n.png
  if cmp -s "pkg/$f" "run/$f"; then echo "== $f (cmp) IDENTIQUE"; ok=$((ok+1))
  else echo "== $f (cmp) DIFFERENT"; ko=$((ko+1)); fi
done
echo "TOTAL identiques=$ok differents=$ko"
