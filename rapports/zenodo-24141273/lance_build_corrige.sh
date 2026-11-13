#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24141273/lance_build_corrige.sh rapports/zenodo-24141273/Containerfile.corrige sd-92569:work/z24141273/
#   bin/capture.sh rapports/zenodo-24141273/build_corrige_235.log 'cd ~/work/z24141273 && sh lance_build_corrige.sh'
# (build_corrige_235.log : 2.3.5, mais l'archivage a échoué, code 125, fichier déjà présent ; relancé après ajout du rm -f,
#  sortie dans build_corrige_235b.log : bin/capture.sh rapports/zenodo-24141273/build_corrige_235b.log '<même commande>'.)
# (build_corrige.log = première tentative, avec numpy 2.4.4 : même TypeError ; le Containerfile.corrige portait alors 2.4.4.)
# Image de la section « Hors paquet » (numpy 2.4.4). Contexte de construction = build2/ (Containerfile seul).
rm -rf build2 && mkdir build2
cp Containerfile.corrige build2/Containerfile
podman build -t replab-fiscal-corrige -f build2/Containerfile build2
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-fiscal-corrige python3 -c "import numpy as np; print(np.__version__); print(float(np.array([[1.0]])))"
echo "code de sortie test float : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-fiscal-corrige python3 -m pip freeze
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-fiscal-corrige python3 --version
rm -f ~/images/zenodo-24141273-corrige.tar   # la tentative numpy 2.4.4 avait déjà archivé son image sous ce nom
podman save -o ~/images/zenodo-24141273-corrige.tar localhost/replab-fiscal-corrige
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24141273-corrige.tar
podman images --digests localhost/replab-fiscal-corrige
