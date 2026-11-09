#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23511350/lance_numpy.sh rapports/zenodo-23511350/Containerfile sd-92569:work/z23511350/
#   bin/capture.sh rapports/zenodo-23511350/executions_numpy.log 'cd ~/work/z23511350 && sh lance_numpy.sh'
# Prérequis : pkg/ extrait (extraction.log).
OPTS="--network none --cap-drop all --security-opt no-new-privileges --read-only"
P=/pkg/DFAR_Replication_Package

echo "== construction de l'image replab-dfar-numpy (réseau : PyPI seulement)"
podman build -t replab-dfar-numpy -f Containerfile .
echo "code de sortie build : $?"
podman run --rm $OPTS replab-dfar-numpy python3 -c "import numpy; print('numpy', numpy.__version__)"

echo "== C. commande du guide avec NumPy : python3 run_verification_suite.py"
podman run --rm $OPTS -v "$PWD/pkg:/pkg:ro" -w $P replab-dfar-numpy python3 run_verification_suite.py
echo "code de sortie C : $?"
podman images
