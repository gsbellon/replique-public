#!/bin/bash
# Remesure du mode A (par défaut) sur une copie neuve, et constats cités dans le rapport.
# Ligne d'appel (depuis le pilote, à la racine du dépôt, après scp de ce fichier) :
#   scp rapports/zenodo-23439616/mesure_A.sh sd-92569:work/z23439616/
#   bin/capture.sh rapports/zenodo-23439616/mesure_A.log 'cd ~/work/z23439616 && bash mesure_A.sh'
# Le mode A n'exécute que le code du paquet, dans le conteneur (--network none).
cd ~/work/z23439616 || exit 1
rm -rf run3 && mkdir run3
python3 -I -m zipfile -e pkg.zip run3 || exit 1
echo "== arbre extrait"; ls run3 run3/* | head -40
echo "== digest image"; podman images --format "{{.Repository}}:{{.Tag}} {{.Digest}}"
echo "== python dans l'image"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges docker.io/library/python:3.12-slim python -V
echo "== exécution A (durée par le builtin time)"
R=$(dirname "$(find run3 -name reproduce_results_cnsns.py | head -1)")
echo "répertoire du paquet : $R"
TIMEFORMAT='real %R s  user %U s  sys %S s'
time podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -e HOME=/tmp \
  -v "$PWD/deps:/deps:ro" -v "$PWD/$R:/pkg:rw" -w /pkg docker.io/library/python:3.12-slim \
  python -I -c "import sys,runpy;sys.path.insert(0,'/deps');sys.argv=['reproduce_results_cnsns.py'];runpy.run_path('/pkg/reproduce_results_cnsns.py',run_name='__main__')" > run3.log 2>&1
echo "code retour A : $?"
echo "== comparaison run3 / pristine_code"
for f in study geometry graded; do
  echo "-- $f"
  python3 -I compare.py pristine_code/results_cnsns_$f.json $R/code/results_cnsns_$f.json
done
echo "== sha256 run3"; sha256sum $R/code/results_cnsns_*.json
echo "== figures et tables"; ls $R/article $R/article/figures
echo "== nombre de trajectoires dans les JSON fournis (clés de premier niveau)"
python3 -I -c "
import json
for f in ['study','geometry','graded']:
    d=json.load(open('pristine_code/results_cnsns_%s.json'%f))
    print(f, type(d).__name__, list(d.keys())[:12] if isinstance(d,dict) else len(d))
"
echo "== JSON triés identiques (geometry, B vs fourni)"
python3 -I -c "
import json
a=json.load(open('pristine_code/results_cnsns_geometry.json')); b=json.load(open('run2/code/results_cnsns_geometry.json'))
print('dumps trié identique:', json.dumps(a,sort_keys=True)==json.dumps(b,sort_keys=True))
print('dumps non trié identique:', json.dumps(a)==json.dumps(b))
print('ordre des clés identique:', list(a.keys())==list(b.keys()))
"
