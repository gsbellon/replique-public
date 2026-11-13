#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24141273/lance_run.sh sd-92569:work/z24141273/
#   bash bin/lance_detache.sh work/z24141273 lance_run.sh run.out     (durée prévue > 1 h : exécution détachée)
# Suit le README du paquet : `python run_all.py` (construit le jeu maître puis lance toutes les analyses).
# Le paquet est copié dans run/ ; l'original reste intact dans pkg/ (référence de la comparaison). Les sorties livrées
# (output/tables, figures, results, run_all.log) sont supprimées de la copie : tout ce qui s'y trouve ensuite a été
# régénéré. Image replab-fiscal, sans réseau, sans capacité, racine en lecture seule ; borne de 4 h (timeout).
cd ~/work/z24141273 || exit 1
rm -rf run && mkdir run
cp -a pkg/replication_package_v1.0.1/. run/
rm -rf run/output && mkdir run/output
echo "début : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
nproc
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-fiscal timeout 14400 python3 run_all.py
echo "code run_all : $?"
echo "durée run_all (s) : $(( $(date +%s) - t0 ))"
echo "fin : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
touch ~/work/z24141273/TERMINE
