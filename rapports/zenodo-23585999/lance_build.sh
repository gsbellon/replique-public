#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585999/lance_build.sh rapports/zenodo-23585999/Containerfile sd-92569:work/z23585999/
#   bin/capture.sh rapports/zenodo-23585999/build.log 'cd ~/work/z23585999 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile + requirements-lock.txt copié du paquet extrait ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
cp pkg/requirements-lock.txt build/
podman build -t replab-ai306 -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-ai306 python3 -c 'import sys,numpy,scipy,pandas,matplotlib,mpmath; print(sys.version); print(numpy.__version__, scipy.__version__, pandas.__version__, matplotlib.__version__, mpmath.__version__)'
podman images
