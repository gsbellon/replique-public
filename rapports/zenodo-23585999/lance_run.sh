#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585999/lance_run.sh sd-92569:work/z23585999/
#   bin/capture.sh rapports/zenodo-23585999/lancement.log 'cd ~/work/z23585999 && sh lance_run.sh'
# Suit la séquence du README : verify_release.py --manifest (avant, au premier plan), puis run_all.py, puis verify_release.py
# (les deux derniers dans un conteneur DÉTACHÉ replab-ai306-run, durée inconnue). Conteneur sans réseau, sans capacité, racine en
# lecture seule, seul run/ monté. Le paquet est copié dans run/ (inscriptible) : les scripts écrivent dans leurs dossiers.
rm -rf run && mkdir run
cp -a pkg/. run/
date -u +%Y-%m-%dT%H:%M:%SZ
podman rm -f replab-ai306-run 2>/dev/null
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  replab-ai306 python3 verify_release.py --manifest
echo "code verify --manifest : $?"
podman run -d --name replab-ai306-run --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  replab-ai306 sh -c 'python3 run_all.py; echo "code run_all : $?"; python3 verify_release.py; echo "code verify : $?"'
date -u +%Y-%m-%dT%H:%M:%SZ
podman ps -a
