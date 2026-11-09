#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/lance_build.sh rapports/zenodo-23758240/Containerfile sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/build.log 'cd ~/work/z23758240 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile + requirements.txt copié du paquet extrait ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
cp pkg/autoscaling-sensitivity-study/requirements.txt build/
podman build -t replab-autoscaling -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-autoscaling python3 -c 'import sys,numpy,scipy,pandas,matplotlib; print(sys.version); print(numpy.__version__, scipy.__version__, pandas.__version__, matplotlib.__version__)'
podman images
