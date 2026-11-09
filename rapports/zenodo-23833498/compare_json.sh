#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23833498/compare_json.sh rapports/zenodo-23833498/compare_json.py sd-92569:work/z23833498/
#   bin/capture.sh rapports/zenodo-23833498/compare_json.log 'cd ~/work/z23833498 && sh compare_json.sh'
for f in archetype_results.json extended_results.json robustness_results.json; do
  echo "=== $f"
  python3 -I compare_json.py "pkg/$f" "run/$f"
done
