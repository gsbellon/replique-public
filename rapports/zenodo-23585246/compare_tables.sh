#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/compare_tables.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/comparaison_tables.log 'cd ~/work/z23585246 && sh compare_tables.sh'
# Compare octet à octet chaque CSV de run/output/tables (régénéré) avec celui du paquet (pkg/, copie intacte).
# Une ligne par fichier : IDENTIQUE, DIFFERE (avec nombre de lignes différentes) ou ABSENT.
P=pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/output/tables
R=run/output/tables
for f in $(ls $P); do
  if [ ! -f "$R/$f" ]; then echo "ABSENT $f"; continue; fi
  if cmp -s "$P/$f" "$R/$f"; then echo "IDENTIQUE $f"
  else echo "DIFFERE $f ($(diff "$P/$f" "$R/$f" | grep -c '^<') lignes fournies differentes, $(wc -l < "$P/$f") lignes au total)"; fi
done
echo "fichiers regeneres absents du paquet :"
for f in $(ls $R); do [ -f "$P/$f" ] || echo "EN_PLUS $f"; done
echo "total fournis : $(ls $P | wc -l) ; regeneres : $(ls $R | wc -l)"
