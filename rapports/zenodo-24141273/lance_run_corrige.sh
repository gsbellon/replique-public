#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24141273/lance_run_corrige.sh sd-92569:work/z24141273/
#   bash bin/lance_detache.sh work/z24141273 lance_run_corrige.sh run2.out     (durée prévue > 1 h : exécution détachée)
# Section « Hors paquet » : même commande que lance_run.sh (`python run_all.py`), image replab-fiscal-corrige
# (numpy 2.3.5 au lieu de 2.5.3, seule différence, voir Containerfile.corrige), répertoire run2/.
# Le paquet est copié dans run2/ ; l'original reste intact dans pkg/. Les sorties livrées sont supprimées de la copie.
cd ~/work/z24141273 || exit 1
rm -rf run2 && mkdir run2
cp -a pkg/replication_package_v1.0.1/. run2/
rm -rf run2/output && mkdir run2/output
echo "début : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
nproc
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run2:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-fiscal-corrige timeout 14400 python3 run_all.py
echo "code run_all : $?"
echo "durée run_all (s) : $(( $(date +%s) - t0 ))"
echo "fin : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
touch ~/work/z24141273/TERMINE2
