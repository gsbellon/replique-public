#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23652337/lance_build.sh rapports/zenodo-23652337/Containerfile sd-92569:work/z23652337/
#   bin/capture.sh rapports/zenodo-23652337/build.log 'cd ~/work/z23652337 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-reach -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-reach python3 -c 'import sys,numpy,scipy,pandas,matplotlib,pyarrow,statsmodels; print(sys.version); print(numpy.__version__, scipy.__version__, pandas.__version__, matplotlib.__version__, pyarrow.__version__, statsmodels.__version__)'
podman images
