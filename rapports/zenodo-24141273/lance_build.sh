#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   ssh sd-92569 'mkdir -p work/z24141273'   (déjà créé par le téléchargement)
#   scp rapports/zenodo-24141273/lance_build.sh rapports/zenodo-24141273/Containerfile sd-92569:work/z24141273/
#   bin/capture.sh rapports/zenodo-24141273/build.log 'cd ~/work/z24141273 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-fiscal -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-fiscal python3 -m pip freeze
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-fiscal python3 --version
mkdir -p ~/images
podman save -o ~/images/zenodo-24141273.tar localhost/replab-fiscal
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24141273.tar
podman images --digests
