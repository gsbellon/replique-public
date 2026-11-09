#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/compare.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/comparaison.log 'cd ~/work/z23624408 && sh compare.sh'
# Compare octet à octet chaque fichier de résultats fourni (pkg/output) à son homologue régénéré (out).
# Aucun code du paquet n'est exécuté ; cmp seulement. Les sommes SHA-256 des deux côtés sont aussi relevées.
cd ~/work/z23624408
same=0; diff=0; missing=0
for f in $(cd pkg/output && find . -type f | sort); do
  if [ ! -f "out/$f" ]; then echo "ABSENT  $f"; missing=$((missing+1))
  elif cmp -s "pkg/output/$f" "out/$f"; then echo "IDENTIQUE $f"; same=$((same+1))
  else echo "DIFFERENT $f"; diff=$((diff+1)); fi
done
echo "TOTAL identiques=$same differents=$diff absents=$missing"
echo "fichiers présents seulement dans out :"
for f in $(cd out && find . -type f | sort); do [ -f "pkg/output/$f" ] || echo "  $f"; done
