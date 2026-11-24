#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/diag_vix.sh rapports/zenodo-23585246/diag_vix.py sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/diag_vix.log 'cd ~/work/z23585246 && sh diag_vix.sh'
# Conteneur sans réseau ; run/ monté en lecture seule, script monté depuis un répertoire distinct.
mkdir -p diag && cp diag_vix.py diag/
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:ro" -v "$PWD/diag:/diag:ro" -w /work replab-oilecu python3 -I /diag/diag_vix.py
echo "code : $?"
