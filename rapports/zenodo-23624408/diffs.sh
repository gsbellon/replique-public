#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/diffs.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/diffs.log 'cd ~/work/z23624408 && sh diffs.sh'
# Montre les différences ligne à ligne (diff) entre résultats fournis (pkg/output) et régénérés (out).
cd ~/work/z23624408
for f in national/brazil.csv municipal/table2_municipalities.csv national/regions.csv national/dominance.csv municipal/table1_descriptives.csv national/descriptives_brazil.csv audit/subgroup_consistency.csv robustness/zero_constant.csv; do
  echo "=== $f  (< fourni, > régénéré)"
  diff pkg/output/$f out/$f
done
echo "=== inputs_sha256.csv"; cmp pkg/output/inputs_sha256.csv out/inputs_sha256.csv && echo identique
echo "=== session_info (fourni)"; cat pkg/output/session_info.txt
echo "=== session_info (régénéré)"; cat out/session_info.txt
