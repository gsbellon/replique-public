#!/bin/sh
# Ligne d'appel (depuis le pilote, dans rapports/zenodo-23439616/) :
#   scp compare.py lance_comparaison.sh sd-92569:work/z23439616/
#   bin/capture.sh rapports/zenodo-23439616/comparaison.log 'cd ~/work/z23439616 && sh lance_comparaison.sh'
# Prérequis : compare.py présent dans ~/work/z23439616 sur sd-92569.
# Référence : pristine_code/ (JSON fournis, copiés avant exécution) ; obtenu : run/code/ (A), run2/code/ (B).
for r in run run2; do for f in study geometry graded; do
  echo "== $r results_cnsns_$f.json"
  python3 -I compare.py pristine_code/results_cnsns_$f.json $r/code/results_cnsns_$f.json
done; done
echo "== sha256"; sha256sum pristine_code/results_cnsns_*.json run/code/results_cnsns_*.json run2/code/results_cnsns_*.json
echo "== md5 zip"; md5sum pkg.zip
