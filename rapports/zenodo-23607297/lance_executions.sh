#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23607297/lance_executions.sh sd-92569:work/z23607297/
#   bin/capture.sh rapports/zenodo-23607297/executions.log 'cd ~/work/z23607297 && sh lance_executions.sh'
# Prérequis : pkg/ contient les 4 fichiers du dépôt Zenodo 23607297 (voir telechargement.log).
# Options conteneur : celles de bin/sandbox-args.txt ; pas de réseau, paquet monté en lecture seule.
OPTS="--network none --cap-drop all --security-opt no-new-privileges --read-only"
IMG=docker.io/library/python:3.12-slim

echo "== A. script tel que livré, python recompute_from_release.py, répertoire = paquet"
podman run --rm $OPTS -v "$PWD/pkg:/pkg:ro" -w /pkg $IMG python -I recompute_from_release.py
echo "code de sortie A : $?"

echo "== chemin attendu par le script"
grep -n "^CSV" pkg/recompute_from_release.py

echo "== B. copie modifiée : seule la ligne CSV = ... remplacée par /pkg/ltb_per_model_zscores.csv"
rm -rf patch && mkdir patch
sed "s#^CSV = .*#CSV = r'/pkg/ltb_per_model_zscores.csv'#" pkg/recompute_from_release.py > patch/recompute_patched.py
diff pkg/recompute_from_release.py patch/recompute_patched.py
podman run --rm $OPTS -v "$PWD/pkg:/pkg:ro" -v "$PWD/patch:/patch:ro" -w /patch $IMG python -I recompute_patched.py
echo "code de sortie B : $?"

echo "== md5"; md5sum pkg/* patch/*
