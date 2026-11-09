#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/lance_build.sh rapports/zenodo-23624408/Containerfile sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/build.log 'cd ~/work/z23624408 && sh lance_build.sh'
# Construit l'image (réseau : apt Debian et CRAN, construction seulement) et relève les versions.
podman build -t replab-deamph -f Containerfile .
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-deamph Rscript -e 'cat(R.version.string, "\n"); for (p in c("data.table","rDEA","lpSolve")) cat(p, as.character(packageVersion(p)), "\n")'
podman images
