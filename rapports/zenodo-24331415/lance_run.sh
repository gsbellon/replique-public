#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24331415/lance_run.sh sd-92569:work/z24331415/
#   bin/capture.sh rapports/zenodo-24331415/run.log 'cd ~/work/z24331415 && sh lance_run.sh'
# Contrôles rapides 1, 5 (et l'auto-test d'intervalles de 2) du README du paquet, dans l'image replab-lyap
# (Python 3.11, numpy 2.1.1, scipy 1.13.1), sans réseau, sans capacité, racine en lecture seule.
# Le paquet est copié dans run/ (cp -a) : l'original reste intact dans pkg/ pour la comparaison (compare.sh).
P=pkg/lyapunov-maxplus-certification-v1.0.0
rm -rf run && mkdir run
cp -a $P/. run/
mkdir run/fd
cp run/feeders/*.dss run/feeders/*.DSS run/fd/
O="--rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
D="-v $PWD/run:/work:rw -w /work/code -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1"
date -u +%Y-%m-%dT%H:%M:%SZ
echo "=================== python3 paper_numbers.py"
podman run $O $D localhost/replab-lyap timeout 1800 python3 paper_numbers.py
echo "code : $?"
echo "=================== python3 supp_numbers.py"
podman run $O $D localhost/replab-lyap timeout 1800 python3 supp_numbers.py
echo "code : $?"
echo "=================== python3 test_ival.py"
podman run $O $D localhost/replab-lyap timeout 1800 python3 test_ival.py
echo "code : $?"
echo "=================== python3 tools/feeder_parse.py /work/fd"
podman run $O $D localhost/replab-lyap timeout 1800 python3 tools/feeder_parse.py /work/fd
echo "code : $?"
echo "=================== python3 tools/feeder_mesh.py /work/fd"
podman run $O $D localhost/replab-lyap timeout 1800 python3 tools/feeder_mesh.py /work/fd
echo "code : $?"
date -u +%Y-%m-%dT%H:%M:%SZ
