#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23647165/lance_build.sh rapports/zenodo-23647165/Containerfile sd-92569:work/z23647165/
#   bin/capture.sh rapports/zenodo-23647165/build.log 'cd ~/work/z23647165 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-eroi -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-eroi python3 -c 'import sys,numpy,scipy; print(sys.version); print(numpy.__version__, scipy.__version__)'
podman images
