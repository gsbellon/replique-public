#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-24353093/compare.sh sd-92569:work/z24353093/
#   bin/capture.sh rapports/zenodo-24353093/compare.log 'cd ~/work/z24353093 && sh compare.sh'
# Livré = pkg/ ; régénéré = runB/ (lance_run.sh, avec le module de remplacement, HORS PAQUET).
# Critère (CRITERE.md) : JSON par bin/compare_json.py --rtol 1e-6 --atol 1e-9 ; images par cmp/sha256sum (hors verdict).
cd ~/work/z24353093 || exit 1
echo "=== JSON, critère du 6 ter (rtol 1e-6, atol 1e-9)"
python3 -I compare_json.py --rtol 1e-6 --atol 1e-9 --max-detail 200 pkg/WCHN_partial_correlations_results.json runB/WCHN_partial_correlations_results.json
echo "=== JSON, égalité exacte (information)"
python3 -I compare_json.py --max-detail 200 pkg/WCHN_partial_correlations_results.json runB/WCHN_partial_correlations_results.json | tail -5
echo "=== JSON octet par octet"
cmp pkg/WCHN_partial_correlations_results.json runB/WCHN_partial_correlations_results.json && echo "identique (cmp)"
echo "=== images : cmp et sha256sum (hors verdict)"
for f in Reduced_PCA_Cerrado_74_WCHNs.png Reduced_PCA_Caatinga_24_WCHNs.png WCHN_Cerrado_PCA_ajustada_SigmaNO.png WCHN_Cerrado_PCA_ajustada_SigmaNO.svg WCHN_Caatinga_PCA_ajustada_SigmaNO.png WCHN_Caatinga_PCA_ajustada_SigmaNO.svg; do
  if cmp pkg/$f runB/$f; then echo "== $f : identique (cmp)"; else echo "== $f : DIFFERE (cmp)"; fi
  sha256sum pkg/$f runB/$f
done
echo "=== fichiers différents entre pkg et runB"
diff -rq pkg runB
