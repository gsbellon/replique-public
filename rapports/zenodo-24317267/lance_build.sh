#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24317267/lance_build.sh rapports/zenodo-24317267/Containerfile sd-92569:work/z24317267/
#   bin/capture.sh rapports/zenodo-24317267/build.log 'cd ~/work/z24317267 && sh lance_build.sh'
# Contexte de construction = build/ : le Containerfile seul. Archive l'image et relève son empreinte.
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-blowcrawford -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-blowcrawford Rscript -e 'print(R.version.string); for (p in c("lpSolve","foreign","lubridate","fmsb","generics","timechange","cpp11")) cat(p, as.character(packageVersion(p)), "\n")'
mkdir -p ~/images
rm -f ~/images/zenodo-24317267.tar
podman save -o ~/images/zenodo-24317267.tar localhost/replab-blowcrawford
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24317267.tar
podman image inspect --format '{{.Id}}' localhost/replab-blowcrawford
