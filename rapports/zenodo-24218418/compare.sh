#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24218418/compare.sh bin/compare_csv.py sd-92569:work/z24218418/
#   bin/capture.sh rapports/zenodo-24218418/compare.log 'cd ~/work/z24218418 && sh compare.sh'
# Compare les 7 fichiers de resultados/ réécrits par lance_run.sh (pkg/ = livré, run/ = régénéré) :
#  - CSV : comparateur commun bin/compare_csv.py, égalité exacte puis tolérance relative 1e-9 ;
#  - JSON : octet par octet (cmp), puis diff ligne à ligne (au plus 40 lignes affichées par fichier).
cd ~/work/z24218418 || exit 1
for f in tabla1_conversaciones consensos_polis_tipados lambda_star tipologia_por_conversacion; do
  echo "== CSV $f.csv : exact"
  python3 -I compare_csv.py pkg/resultados/$f.csv run/resultados/$f.csv | tail -15
  echo "== CSV $f.csv : rtol 1e-9"
  python3 -I compare_csv.py --rtol 1e-9 pkg/resultados/$f.csv run/resultados/$f.csv | tail -15
done
for f in cifras cifras_extras sensibilidad_paso; do
  echo "== JSON $f.json"
  cmp pkg/resultados/$f.json run/resultados/$f.json
  diff pkg/resultados/$f.json run/resultados/$f.json | head -40
done
echo "== fins de ligne (nombre de CR)"
for f in tabla1_conversaciones.csv consensos_polis_tipados.csv lambda_star.csv tipologia_por_conversacion.csv cifras.json cifras_extras.json sensibilidad_paso.json; do
  echo "$f livré: $(tr -cd '\r' < pkg/resultados/$f | wc -c) régénéré: $(tr -cd '\r' < run/resultados/$f | wc -c) ; octets livré: $(wc -c < pkg/resultados/$f) régénéré: $(wc -c < run/resultados/$f)"
done
