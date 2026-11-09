#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23673342/lance_agg.sh sd-92569:work/z23673342/
#   bin/capture.sh rapports/zenodo-23673342/run_agg.log 'cd ~/work/z23673342 && sh lance_agg.sh'
# Chemins « sans microdonnées » du README (section Replication paths) : (1) tests/check_results.R et tests/review_v4.R
# sur le paquet livré ; (2) tests/prepare_aggregate_profiles.R puis run_all.R 05 08 10 11 sur une autre copie.
# Copies dans run_agg1/ et run_agg2/ (inscriptibles) ; l'original reste intact dans pkg/. Image replab-bodmpi,
# sans réseau, sans capacité, racine en lecture seule.
rm -rf run_agg1 run_agg2
mkdir run_agg1 run_agg2
cp -a pkg/. run_agg1/
cp -a pkg/. run_agg2/
for c in "tests/check_results.R" "tests/review_v4.R"; do
  echo "=================== run_agg1 : Rscript $c"
  date -u +%Y-%m-%dT%H:%M:%SZ
  timeout 3000 podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
    -v "$PWD/run_agg1:/work:rw" -w /work -e HOME=/tmp localhost/replab-bodmpi Rscript "$c"
  echo "code $c : $?"
done
for c in "tests/prepare_aggregate_profiles.R" "run_all.R 05 08 10 11"; do
  echo "=================== run_agg2 : Rscript $c"
  date -u +%Y-%m-%dT%H:%M:%SZ
  timeout 3000 podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
    -v "$PWD/run_agg2:/work:rw" -w /work -e HOME=/tmp localhost/replab-bodmpi Rscript $c
  echo "code $c : $?"
done
date -u +%Y-%m-%dT%H:%M:%SZ
echo FIN
