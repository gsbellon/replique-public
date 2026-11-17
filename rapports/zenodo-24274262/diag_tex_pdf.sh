#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/diag_tex_pdf.sh sd-92569:work/z24274262/
#   bin/capture.sh rapports/zenodo-24274262/diag_tex_pdf.log 'cd ~/work/z24274262 && sh diag_tex_pdf.sh'
# Explique les écarts octet à octet de compare.log : nombre de lignes .tex différentes, aperçu, métadonnées des PDF.
cd ~/work/z24274262 || exit 1
L=data/derived/tables
R=run_mtime/results/tables
for f in mode_comparison_best_so_far.tex mode_comparison_hv_stats.tex mode_comparison_best_so_far_stats.tex; do
  echo "== diff $f : lignes différentes (diff | grep -c '^<')"
  diff $L/$f $R/$f | grep -c '^<'
  echo "== diff $f : début"
  diff $L/$f $R/$f | head -8
done
echo "== PDF : en-têtes de métadonnées (strings | grep Date) de branin__best_so_far, livré puis régénéré"
strings data/derived/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf | grep -i 'date\|producer\|creator' | head -6
strings run_mtime/results/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf | grep -i 'date\|producer\|creator' | head -6
echo "== PDF : octets livré / régénéré, nombre d'octets différents (cmp -l | wc -l)"
wc -c data/derived/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf run_mtime/results/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf
cmp -l data/derived/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf run_mtime/results/figures/branin__best_so_far_gen200_runs100_psizes12-36-60.pdf | wc -l
