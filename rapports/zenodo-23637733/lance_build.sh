#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/lance_build.sh rapports/zenodo-23637733/Containerfile sd-92569:work/z23637733/
#   bin/capture.sh rapports/zenodo-23637733/build.log 'cd ~/work/z23637733 && sh lance_build.sh'   (1re tentative, Python 3.14 : échec)
#   bin/capture.sh rapports/zenodo-23637733/build_py313.log 'cd ~/work/z23637733 && sh lance_build.sh'   (Containerfile actuel, Python 3.13)
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-evid -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-evid python3 -c 'import sys,numpy,scipy,pandas,pyarrow,pytest; print(sys.version); print(numpy.__version__, scipy.__version__, pandas.__version__, pyarrow.__version__, pytest.__version__)'
podman images
