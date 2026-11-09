#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/test_graine7.py rapports/zenodo-23758240/lance_test_graine7.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/test_graine7.log 'cd ~/work/z23758240 && sh lance_test_graine7.sh'
# Même conteneur que l'exécution (sans réseau, sans capacité, racine en lecture seule) ; le livré est monté en lecture seule.
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/pkg/autoscaling-sensitivity-study/results:/res:ro" -v "$PWD/test_graine7.py:/t/test_graine7.py:ro" \
  -w /tmp -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  replab-autoscaling python /t/test_graine7.py /res
