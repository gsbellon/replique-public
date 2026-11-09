#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23595707/lance_executions.sh sd-92569:work/z23595707/
#   bin/capture.sh rapports/zenodo-23595707/executions.log 'cd ~/work/z23595707 && sh lance_executions.sh'
# Prérequis : pkg/ extrait par extrait.sh (extraction.log). Options conteneur : celles de bin/sandbox-args.txt.
# Paquet monté en lecture seule ; seul /out (répertoire vide créé ici) est inscriptible. Aucun réseau.
OPTS="--network none --cap-drop all --security-opt no-new-privileges --read-only"
IMG=docker.io/library/python:3.12-slim
P=/pkg/qsurvdiag-replication-v1.3.0
rm -rf out && mkdir out
RUN="podman run --rm $OPTS -v $PWD/pkg:/pkg:ro -v $PWD/out:/out:rw -w $P $IMG"

$RUN python3 --version
echo "== 0. openssl dans l'image ?"
$RUN sh -c 'command -v openssl; echo "code: $?"'

echo "== 1. python3 scripts/verify_integrity.py (sans --tsr)"
$RUN python3 scripts/verify_integrity.py
echo "code de sortie 1 : $?"

echo "== 1b. python3 scripts/verify_integrity.py --tsr"
$RUN python3 scripts/verify_integrity.py --tsr
echo "code de sortie 1b : $?"

echo "== 2. python3 scripts/reproduce.py --out /out"
$RUN python3 scripts/reproduce.py --out /out
echo "code de sortie 2 : $?"

echo "== 3. python3 scripts/run_conformance_tests.py --out /out"
$RUN python3 scripts/run_conformance_tests.py --out /out
echo "code de sortie 3 : $?"

echo "== 4. python3 scripts/reproduce_experiments.py --out /out/experiments"
$RUN python3 scripts/reproduce_experiments.py --out /out/experiments
echo "code de sortie 4 : $?"

echo "== md5"; md5sum QS.zip
