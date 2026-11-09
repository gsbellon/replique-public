#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23735615/lance_build.sh rapports/zenodo-23735615/Containerfile sd-92569:work/z23735615/
#   bin/capture.sh rapports/zenodo-23735615/build.log 'cd ~/work/z23735615 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-quarantine -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-quarantine python3 -c 'import sys,numpy,scipy,matplotlib,pytest; print(sys.version); print(numpy.__version__, scipy.__version__, matplotlib.__version__, pytest.__version__)'
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-quarantine git --version
podman images
