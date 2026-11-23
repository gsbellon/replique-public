#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24353093/lance_build.sh rapports/zenodo-24353093/Containerfile sd-92569:work/z24353093/
#   bin/capture.sh rapports/zenodo-24353093/build.log 'cd ~/work/z24353093 && sh lance_build.sh'
# Contexte de construction = build/ : le Containerfile seul (aucun fichier du paquet). Archive l'image et relève son empreinte.
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-wchn -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-wchn python -c "import sys, numpy, scipy, matplotlib; print(sys.version); print('numpy', numpy.__version__, 'scipy', scipy.__version__, 'matplotlib', matplotlib.__version__)"
mkdir -p ~/images
rm -f ~/images/zenodo-24353093.tar
podman save -o ~/images/zenodo-24353093.tar localhost/replab-wchn
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24353093.tar
podman image inspect --format '{{.Id}}' localhost/replab-wchn
