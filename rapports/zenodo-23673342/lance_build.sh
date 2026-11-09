#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23673342/lance_build.sh rapports/zenodo-23673342/Containerfile sd-92569:work/z23673342/
#   bin/capture.sh rapports/zenodo-23673342/build.log 'cd ~/work/z23673342 && sh lance_build.sh'
# Contexte de construction = build/ (Containerfile seul ; aucun code du paquet).
rm -rf build && mkdir build
cp Containerfile build/
podman build -t replab-bodmpi -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-bodmpi Rscript -e 'cat(R.version.string, "\n"); for (p in c("data.table","lpSolve","rDEA","Benchmarking")) cat(p, as.character(packageVersion(p)), "\n")'
podman images
