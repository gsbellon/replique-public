#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23864979/lance_run.sh sd-92569:work/z23864979/
#   bin/capture.sh rapports/zenodo-23864979/run.log 'cd ~/work/z23864979 && sh lance_run.sh'
# Suit la section « Running » du README : les six scripts A à F, chacun indépendant, sortie standard capturée.
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/. Image replab-cournot, sans réseau,
# sans capacité, racine en lecture seule ; durée de chaque script bornée à 50 min (timeout).
rm -rf run && mkdir run
cp -a pkg/cost_dispersion_networks_replication_v4.0/. run/
for s in A_closed_forms B_atlas_search C_wheel_example D_random_draws E_curvature_corners_figures F_policy_transfers; do
  echo "=================== $s.py"
  date -u +%Y-%m-%dT%H:%M:%SZ
  t0=$(date +%s)
  podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
    -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
    localhost/replab-cournot timeout 3000 python3 "$s.py"
  echo "code $s : $?"
  echo "durée $s (s) : $(( $(date +%s) - t0 ))"
done
echo "=================== fichiers produits dans run/"
ls -l run
