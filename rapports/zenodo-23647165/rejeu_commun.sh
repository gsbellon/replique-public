#!/bin/sh
# Rejeu de la comparaison par le comparateur commun JSON (article 5 bis, tâche 2 de TACHES.md).
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-23647165/rejeu_commun.sh sd-92569:work/z23647165/
#   bin/capture.sh rapports/zenodo-23647165/rejeu_commun.log 'cd ~/work/z23647165 && sh rejeu_commun.sh'
# Livré : pkg/replication/output/ ; régénéré : run/output/. Le scp écrase, sur l'exécuteur seulement, le compare_json.py
# propre au dossier (conservé dans le dépôt, rapports/zenodo-23647165/compare_json.py) par bin/compare_json.py.
# Chaque JSON est comparé en égalité exacte, puis à rtol 1e-9 / atol 1e-12 (seuils des CSV). Aucun code du paquet n'est exécuté.
cd ~/work/z23647165
for f in verification.json results.json; do
  echo "== $f exact"
  python3 -I compare_json.py pkg/replication/output/$f run/output/$f
  echo "== $f rtol 1e-9 atol 1e-12"
  python3 -I compare_json.py --rtol 1e-9 --atol 1e-12 pkg/replication/output/$f run/output/$f
done
