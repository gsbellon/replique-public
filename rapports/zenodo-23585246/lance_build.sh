#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/lance_build.sh rapports/zenodo-23585246/Containerfile sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/build.log 'cd ~/work/z23585246 && sh lance_build.sh'
# Construit l'image (réseau : apt Debian et CRAN, construction seulement) et relève les versions.
podman build -t replab-oilecu -f Containerfile .
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-oilecu Rscript -e 'cat(R.version.string, "\n"); for (p in c("seasonal","x13binary","urca","strucchange","ggplot2")) cat(p, as.character(packageVersion(p)), "\n")'
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-oilecu python3 -c 'import sys,pandas,numpy,openpyxl,tabulate,matplotlib; print(sys.version); print(pandas.__version__, numpy.__version__, openpyxl.__version__, tabulate.__version__, matplotlib.__version__)'
podman images
