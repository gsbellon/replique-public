#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24331415/lance_build.sh rapports/zenodo-24331415/Containerfile sd-92569:work/z24331415/
#   bin/capture.sh rapports/zenodo-24331415/build.log 'cd ~/work/z24331415 && sh lance_build.sh'
# Contexte de construction = build/ : le Containerfile seul (aucun fichier du paquet). Archive l'image et relève son empreinte.
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-lyap -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-lyap python -c "import sys, numpy, scipy; print(sys.version); print('numpy', numpy.__version__, 'scipy', scipy.__version__)"
mkdir -p ~/images
rm -f ~/images/zenodo-24331415.tar
podman save -o ~/images/zenodo-24331415.tar localhost/replab-lyap
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24331415.tar
podman image inspect --format '{{.Id}}' localhost/replab-lyap
