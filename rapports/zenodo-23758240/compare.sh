#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23758240/compare.sh sd-92569:work/z23758240/
#   bin/capture.sh rapports/zenodo-23758240/comparaison_octets.log 'cd ~/work/z23758240 && sh compare.sh'
# Compare, fichier par fichier, results/ fourni (pkg/) et results/ régénéré (run/) : sha256 puis cmp.
P=pkg/autoscaling-sensitivity-study/results
R=run/results
for f in $(ls $P); do
  a=$(sha256sum < $P/$f | cut -c1-16); b=$(sha256sum < $R/$f 2>/dev/null | cut -c1-16)
  if cmp -s $P/$f $R/$f; then echo "IDENTIQUE $f $a"; else echo "DIFFERENT $f fourni=$a regenere=$b"; fi
done
echo "--- fichiers de run/results absents du paquet :"
for f in $(ls $R); do [ -e $P/$f ] || echo "EN PLUS $f"; done
echo "--- lignes :"
wc -l $P/*.csv $R/*.csv
