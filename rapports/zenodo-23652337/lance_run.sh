#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23652337/lance_run.sh sd-92569:work/z23652337/
#   bin/capture.sh rapports/zenodo-23652337/run.log 'cd ~/work/z23652337 && sh lance_run.sh'
# Suit la section « Quick check » du README : cd code && python3 reproduce_key_numbers.py.
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/. Image replab-reach, sans réseau,
# sans capacité, racine en lecture seule ; durée bornée à 30 min (timeout).
rm -rf run && mkdir run
cp -a pkg/replication_package/. run/
date -u +%Y-%m-%dT%H:%M:%SZ
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work/code -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-reach timeout 1800 python3 reproduce_key_numbers.py
echo "code reproduce_key_numbers : $?"
echo "durée (s) : $(( $(date +%s) - t0 ))"
echo "=================== fichiers modifiés dans run/ par rapport à pkg/"
diff -rq pkg/replication_package run
