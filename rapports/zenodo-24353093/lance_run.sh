#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp -r rapports/zenodo-24353093/lance_run.sh rapports/zenodo-24353093/shim sd-92569:work/z24353093/
#   bin/capture.sh rapports/zenodo-24353093/run.log 'cd ~/work/z24353093 && sh lance_run.sh'
# A : la commande documentée du README (python run_wchn.py), dans une copie du paquet, image replab-wchn,
#     sans réseau, sans capacité, racine en lecture seule.
# B : même commande avec le module de remplacement artifact_tool (HORS PAQUET) sur PYTHONPATH, dans une autre copie.
# Le dossier pkg/ reste intact pour la comparaison (compare.sh).
O="--rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
date -u +%Y-%m-%dT%H:%M:%SZ
rm -rf runA runB && mkdir runA runB
cp -a pkg/. runA/
cp -a pkg/. runB/
echo "=================== A : python run_wchn.py (paquet tel que livre)"
podman run $O -v $PWD/runA:/work:rw -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 -e MPLCONFIGDIR=/tmp localhost/replab-wchn timeout 1800 python run_wchn.py
echo "code A : $?"
echo "=================== B : python run_wchn.py avec artifact_tool de remplacement (HORS PAQUET)"
podman run $O -v $PWD/runB:/work:rw -v $PWD/shim:/shim:ro -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 -e MPLCONFIGDIR=/tmp -e PYTHONPATH=/shim localhost/replab-wchn timeout 1800 python run_wchn.py
echo "code B : $?"
date -u +%Y-%m-%dT%H:%M:%SZ
