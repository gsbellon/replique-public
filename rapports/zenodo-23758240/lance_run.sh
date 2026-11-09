#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/lance_run.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/run.log 'cd ~/work/z23758240 && sh lance_run.sh'
# Suit la section « Reproduce » du README : run_experiments.py, analyse.py, figures.py (README : environ une minute sur 2 cœurs).
# Le paquet est copié dans run/ (inscriptible), la trace téléchargée (telecharge_trace.sh) est placée en data/wiki.csv.
# L'original reste intact dans pkg/ pour la comparaison. Conteneur sans réseau, sans capacité, racine en lecture seule.
rm -rf run && mkdir run
cp -a pkg/autoscaling-sensitivity-study/. run/
cp trace/wiki.csv run/data/wiki.csv
date -u +%Y-%m-%dT%H:%M:%SZ
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 -e MPLCONFIGDIR=/tmp \
  replab-autoscaling sh -c 'python src/run_experiments.py data/wiki.csv results; echo "code run_experiments : $?"; python src/analyse.py results; echo "code analyse : $?"; python src/figures.py results figures data/wiki.csv; echo "code figures : $?"'
date -u +%Y-%m-%dT%H:%M:%SZ
