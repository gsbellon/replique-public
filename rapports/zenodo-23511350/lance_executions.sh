#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23511350/lance_executions.sh sd-92569:work/z23511350/
#   bin/capture.sh rapports/zenodo-23511350/executions.log 'cd ~/work/z23511350 && sh lance_executions.sh'
# Prérequis : pkg/ extrait par extrait.sh (extraction.log). Options conteneur : celles de bin/sandbox-args.txt.
OPTS="--network none --cap-drop all --security-opt no-new-privileges --read-only"
IMG=docker.io/library/python:3.12-slim
P=/pkg/DFAR_Replication_Package

echo "== A. commande du guide : python3 run_verification_suite.py (racine du paquet, monté en lecture seule)"
podman run --rm $OPTS -v "$PWD/pkg:/pkg:ro" -w $P $IMG python3 run_verification_suite.py
echo "code de sortie A : $?"

echo "== numpy présent dans l'image ?"
podman run --rm $OPTS $IMG python3 -c "import numpy; print(numpy.__version__)"
echo "code de sortie numpy : $?"
podman run --rm $OPTS $IMG python3 --version

echo "== md5"; md5sum DFAR.zip
