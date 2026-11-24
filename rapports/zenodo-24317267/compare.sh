#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_csv.py rapports/zenodo-24317267/compare.sh rapports/zenodo-24317267/aplatit_rdata.R sd-92569:work/z24317267/
#   bin/capture.sh rapports/zenodo-24317267/compare.log 'cd ~/work/z24317267 && sh compare.sh'
# Livré = pkg/ ; régénéré = runA/ (lance_run.sh). Critère : CRITERE.md (rtol 1e-6, atol 1e-9 ; .Rdata aplatis puis comparés ;
# images et journaux hors verdict).
cd ~/work/z24317267 || exit 1
O="--rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
rm -rf flat && mkdir -p flat/pkg flat/runA
echo "=== CSV régénérés, critère du 6 ter"
for f in Table_A1_descriptives.csv section5_6_validation_counts.csv unresolved_bound_summary.csv; do
  echo "--- $f"
  python3 -I compare_csv.py --rtol 1e-6 --atol 1e-9 "pkg/output/data/$f" "runA/output/data/$f"
  echo "  (information) égalité exacte :"
  python3 -I compare_csv.py "pkg/output/data/$f" "runA/output/data/$f" | tail -3
  cmp "pkg/output/data/$f" "runA/output/data/$f" && echo "  cmp : identique" || echo "  cmp : octets différents"
  echo "  sha256 livré / régénéré, et fins de ligne (nombre de CR) :"
  sha256sum "pkg/output/data/$f" "runA/output/data/$f"
  tr -cd '\r' < "pkg/output/data/$f" | wc -c
  tr -cd '\r' < "runA/output/data/$f" | wc -c
done
echo "=== Rdata régénérés : aplatissement (R, conteneur) puis comparaison"
i=0
for f in "Table_A1_descriptives.Rdata" "TablesA2_A3_experience.intervals_24_D1000_LPt20_scaled_slope1e-04_final.Rdata" "TableA4_paired_tests.intervals_24_D1000_LPt20_scaled_slope1e-04_final.Rdata" "tuning/Table_A5.Rdata"; do
  i=$((i+1))
  for d in pkg runA; do
    podman run $O -v $PWD/$d/output/data:/in:ro -v $PWD/flat/$d:/out:rw -v $PWD/aplatit_rdata.R:/aplatit_rdata.R:ro -e HOME=/tmp localhost/replab-blowcrawford Rscript /aplatit_rdata.R "/in/$f" "/out/f$i.csv"
  done
  echo "--- [$i] $f"
  python3 -I compare_csv.py --rtol 1e-6 --atol 1e-9 "flat/pkg/f$i.csv" "flat/runA/f$i.csv"
  cmp "pkg/output/data/$f" "runA/output/data/$f" && echo "cmp : identique" || echo "cmp : octets différents (information)"
done
echo "=== entrées livrées (non régénérées) : cmp, doivent être identiques"
for f in "Areas (Both) NestedGeneralU.intervals_24_D1000_LPt20_scaled_slope1e-04_final.Rdata" "Areas (Earnings) NestedGeneralU.intervals_24_D1000_LPt20_scaled_slope1e-04_final.Rdata" "Areas (Hours) NestedGeneralU.intervals_24_D1000_LPt20_scaled_slope1e-04_final.Rdata" tuning/tuning_n12_s1e-04.Rdata tuning/tuning_n16_s1e-04.Rdata tuning/tuning_n16_s1e-05.Rdata tuning/tuning_n24_s1e-03.Rdata tuning/tuning_n24_s1e-04.Rdata tuning/tuning_warp.Rdata; do
  cmp "pkg/output/data/$f" "runA/output/data/$f" && echo "identique : $f"
done
echo "=== images (hors verdict) : cmp et sha256sum"
for f in pkg/output/pics/*.bmp; do
  b=$(basename "$f")
  if cmp -s "$f" "runA/output/pics/$b"; then echo "identique (cmp) : $b"; else echo "DIFFERE (cmp) : $b"; fi
  sha256sum "$f" "runA/output/pics/$b"
done
echo "=== journaux (hors verdict) : diff run_all_log.txt"
echo "lignes de diff (livré contre régénéré) :"
diff pkg/output/run_all_log.txt runA/output/run_all_log.txt | wc -l
echo "lignes d'auto-contrôle (grep) dans le journal livré, puis régénéré :"
grep -n "MATCH\|reproduced exactly\|REVERSALS\|matches the\|differ from" pkg/output/run_all_log.txt
grep -n "MATCH\|reproduced exactly\|REVERSALS\|matches the\|differ from" runA/output/run_all_log.txt
echo "=== diff sessionInfo.txt"
diff pkg/output/sessionInfo.txt runA/output/sessionInfo.txt
echo "=== fichiers présents d'un côté seulement ou différents (diff -rq, hors code/)"
diff -rq pkg/output runA/output
