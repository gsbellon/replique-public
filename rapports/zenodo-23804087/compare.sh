#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23804087/compare.sh sd-92569:work/z23804087/
#   bin/capture.sh rapports/zenodo-23804087/comparaison.log 'cd ~/work/z23804087 && sh compare.sh'
# Compare results/ livré (pkg/results) à results/ régénéré (run/results), puis liste les autres fichiers modifiés par l'exécution.
echo "== diff -rq pkg/results run/results"
diff -rq pkg/results run/results
echo "code diff -rq results : $?"
echo "== diff -rq pkg run (tout le paquet)"
diff -rq pkg run
echo "code diff -rq paquet : $?"
echo "== diff -u (fichiers de results/ qui diffèrent)"
for f in pkg/results/*; do
  b=$(basename "$f")
  if ! cmp -s "$f" "run/results/$b"; then
    echo "--- $b"
    diff -u "$f" "run/results/$b"
  fi
done
echo "== nombre de fichiers : livré / régénéré"
ls pkg/results | wc -l
ls run/results | wc -l
