#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24218418/lance_build.sh rapports/zenodo-24218418/Containerfile sd-92569:work/z24218418/
#   bin/capture.sh rapports/zenodo-24218418/build.log 'cd ~/work/z24218418 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet). Archive l'image et relève son empreinte.
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-polis -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-polis pip freeze
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-polis python3 --version
mkdir -p ~/images
podman save -o ~/images/zenodo-24218418.tar localhost/replab-polis
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24218418.tar
podman image inspect --format '{{.Id}}' localhost/replab-polis
podman images
