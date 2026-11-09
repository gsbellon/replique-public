#!/bin/bash
# Remesure du mode B (recalcul complet --recompute --workers 6) sur une copie neuve.
# Ligne d'appel (depuis le pilote, à la racine du dépôt, après scp de ce fichier) :
#   scp rapports/zenodo-23439616/mesure_B.sh sd-92569:work/z23439616/
#   bin/capture.sh rapports/zenodo-23439616/mesure_B.log 'cd ~/work/z23439616 && bash mesure_B.sh'
cd ~/work/z23439616 || exit 1
rm -rf run4 && mkdir run4
python3 -I -m zipfile -e pkg.zip run4 || exit 1
echo "== CPU de l'hôte"; nproc
TIMEFORMAT='real %R s  user %U s  sys %S s'
time podman run --rm --name z23439616-B --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -e HOME=/tmp \
  -v "$PWD/deps:/deps:ro" -v "$PWD/run4:/pkg:rw" -w /pkg docker.io/library/python:3.12-slim \
  python -I -c "import sys,runpy;sys.path.insert(0,'/deps');sys.argv=['reproduce_results_cnsns.py','--recompute','--workers','6'];runpy.run_path('/pkg/reproduce_results_cnsns.py',run_name='__main__')" > run4.log 2>&1
echo "code retour B : $?"
echo "== comparaison run4 / pristine_code"
for f in study geometry graded; do
  echo "-- $f"
  python3 -I compare.py pristine_code/results_cnsns_$f.json run4/code/results_cnsns_$f.json
done
echo "== sha256 run4"; sha256sum run4/code/results_cnsns_*.json
