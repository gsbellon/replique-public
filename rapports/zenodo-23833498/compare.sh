#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23833498/compare.sh sd-92569:work/z23833498/
#   bin/capture.sh rapports/zenodo-23833498/compare.log 'cd ~/work/z23833498 && sh compare.sh'
# Compare, octet par octet (cmp), les fichiers livrés (pkg/) et les fichiers régénérés (run/) : trois JSON et huit figures.
# Les sommes sha256 des deux jeux sont aussi imprimées.
for f in archetype_results.json extended_results.json robustness_results.json \
         figures/Figure_1.png figures/Figure_2.png figures/Figure_3.png figures/Figure_4.png \
         figures/Figure_5.png figures/Figure_6.png figures/Figure_7.png figures/Figure_8.png; do
  if cmp -s "pkg/$f" "run/$f"; then echo "IDENTIQUE $f"; else echo "DIFFERENT  $f"; fi
done
echo "--- sha256 livrés"
sha256sum pkg/*.json pkg/figures/*.png
echo "--- sha256 régénérés"
sha256sum run/*.json run/figures/*.png
