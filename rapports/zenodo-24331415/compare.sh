#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp bin/compare_json.py rapports/zenodo-24331415/compare.sh sd-92569:work/z24331415/
#   bin/capture.sh rapports/zenodo-24331415/compare.log 'cd ~/work/z24331415 && sh compare.sh'
# Livré = pkg/... ; régénéré = run/... (lance_run.sh). Fichiers texte : cmp et sha256sum (octet par octet) ;
# JSON : bin/compare_json.py (égalité exacte, rien d'ignoré).
cd ~/work/z24331415 || exit 1
P=pkg/lyapunov-maxplus-certification-v1.0.0
echo "=== MD5 annoncés par le README : fcdc7cefe0ecb4006db2972f70b03e32 gen_results.tex ; b13be5402c056f03b5b263aaa5f69892 gen_supp.tex"
md5sum $P/paper/gen_results.tex run/paper/gen_results.tex $P/paper/gen_supp.tex run/paper/gen_supp.tex
for f in paper/gen_results.tex paper/gen_supp.tex notes/numbers_provenance.md notes/numbers_provenance_supp.md; do
  if cmp $P/$f run/$f; then echo "== $f : identique (cmp)"; else echo "== $f : DIFFERE (cmp)"; fi
done
sha256sum $P/paper/gen_results.tex run/paper/gen_results.tex $P/paper/gen_supp.tex run/paper/gen_supp.tex $P/notes/numbers_provenance.md run/notes/numbers_provenance.md $P/notes/numbers_provenance_supp.md run/notes/numbers_provenance_supp.md
echo "=== fichiers produits dans run/fd (hors .dss/.DSS copiés)"
ls -l run/fd
echo "=== feeders : JSON livrés"
ls $P/feeders
for f in $(ls run/fd | grep '\.json$'); do
  echo "== JSON $f : compare_json.py (exact)"
  python3 -I compare_json.py $P/feeders/$f run/fd/$f | tail -8
  if cmp $P/feeders/$f run/fd/$f; then echo "== $f : identique (cmp)"; else echo "== $f : DIFFERE (cmp)"; fi
done
echo "=== fichiers de feeders/ modifiés par l'exécution (run contre pkg)"
for f in $(ls $P/feeders); do
  if cmp -s $P/feeders/$f run/feeders/$f; then :; else echo "modifié : feeders/$f"; fi
done
echo "=== fichiers de code/, paper/, notes/, results/ différents entre pkg et run (find -newer run.log non nécessaire : diff -rq)"
diff -rq $P run | grep -v 'Only in run: fd'
