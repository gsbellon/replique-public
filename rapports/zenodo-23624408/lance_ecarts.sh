#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/lance_ecarts.sh rapports/zenodo-23624408/ecarts.R sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/ecarts.log 'cd ~/work/z23624408 && sh lance_ecarts.sh'
# Script de confiance (ecarts.R) exécuté tout de même en conteneur, sans réseau, entrées en lecture seule.
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/pkg/output:/pkg/output:ro" -v "$PWD/out:/out:ro" -v "$PWD/ecarts.R:/ecarts.R:ro" \
  replab-deamph Rscript /ecarts.R
