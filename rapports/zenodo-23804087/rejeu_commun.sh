#!/bin/sh
# Rejeu de la comparaison par les comparateurs communs (article 5 bis, tâche 3 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-23804087/rejeu_commun.sh sd-92569:work/z23804087/
#   bin/capture.sh rapports/zenodo-23804087/rejeu_commun.log 'cd ~/work/z23804087 && sh rejeu_commun.sh'
# Livré : pkg/results ; régénéré : run/results. Aucun CSV dans ce paquet : les fichiers .json passent par
# bin/compare_json.py (égalité exacte, rien d'ignoré), les .md et .tex par cmp. Aucun code du paquet n'est exécuté.
cd ~/work/z23804087
ok=0; ko=0
for f in $(cd pkg/results && ls | sort); do
  case "$f" in
    *.json)
      res=$(python3 -I compare_json.py "pkg/results/$f" "run/results/$f")
      echo "== $f (compare_json.py)"; echo "$res"
      case "$res" in *"RESULTAT: identique"*) ok=$((ok+1));; *) ko=$((ko+1));; esac;;
    *)
      if cmp -s "pkg/results/$f" "run/results/$f"; then echo "== $f (cmp) IDENTIQUE"; ok=$((ok+1))
      else echo "== $f (cmp) DIFFERENT"; ko=$((ko+1)); fi;;
  esac
done
echo "TOTAL identiques=$ok differents=$ko"
