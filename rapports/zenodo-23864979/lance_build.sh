#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23864979/lance_build.sh rapports/zenodo-23864979/Containerfile sd-92569:work/z23864979/
#   bin/capture.sh rapports/zenodo-23864979/build.log 'cd ~/work/z23864979 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-cournot -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-cournot python3 -c 'import sys,sympy,numpy,scipy,networkx,matplotlib; print(sys.version); print(sympy.__version__, numpy.__version__, scipy.__version__, networkx.__version__, matplotlib.__version__)'
podman images
