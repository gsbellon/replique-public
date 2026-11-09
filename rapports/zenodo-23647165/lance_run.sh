#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23647165/lance_run.sh sd-92569:work/z23647165/
#   bin/capture.sh rapports/zenodo-23647165/run.log 'cd ~/work/z23647165 && sh lance_run.sh'
# Rejoue les deux premières étapes de make.sh (verify_theory.py, calibrate.py), hors réseau. Les figures et les
# documents (figures.py, graphical_abstract.py, build_manuscript.py, pdflatex) ne sont pas rejoués : pdflatex absent.
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/. Les quatre sorties livrées de
# output/ sont supprimées de la copie avant l'exécution, puis comparées aux livrées (diff).
# Image replab-eroi (Python 3.13), sans réseau, sans capacité, racine en lecture seule.
rm -rf run && mkdir run
cp -a pkg/replication/. run/
rm -f run/output/verification.json run/output/results.json run/output/numbers_in_text.json run/output/calibration_log.txt
ls run/output
date -u +%Y-%m-%dT%H:%M:%SZ
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run:/work:rw -v $PWD/data:/data:ro -w /work/code -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-eroi timeout 1200"
etape() {
  echo "=================== ETAPE $*"
  s=$(date +%s)
  $P "$@"
  echo "code de sortie : $?  (durée $(( $(date +%s) - s )) s)"
}
etape python3 verify_theory.py ../output
etape sh -c 'python3 -I calibrate.py /data ../output > ../output/calibration_log.txt'
echo "=================== sorties régénérées"
ls -l run/output
echo "=================== diff livré / régénéré (sortie vide = identique)"
for f in verification.json results.json numbers_in_text.json calibration_log.txt; do
  echo "--- $f"
  cmp pkg/replication/output/$f run/output/$f
  echo "code cmp : $?"
done
