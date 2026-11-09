#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23804087/lance_run.sh sd-92569:work/z23804087/
#   bin/capture.sh rapports/zenodo-23804087/run.log 'cd ~/work/z23804087 && sh lance_run.sh'
# Suit le « Quick start » du README : python3 tools/run_evaluation.py, puis les tests unitaires du paquet.
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/ pour la comparaison.
# Image python:3.12-slim (le paquet ne demande que Python >= 3.9, bibliothèque standard). Sans réseau, sans capacité, racine en lecture seule.
rm -rf run && mkdir run
cp -a pkg/. run/
podman images
date -u +%Y-%m-%dT%H:%M:%SZ
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  docker.io/library/python:3.12-slim sh -c 'python3 --version; python3 tools/run_evaluation.py; echo "code run_evaluation : $?"; python3 -m unittest discover -s tools -p "test_*.py"; echo "code unittest : $?"'
date -u +%Y-%m-%dT%H:%M:%SZ
