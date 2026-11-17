#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/compare.sh rapports/zenodo-24274262/parquet_vers_csv.py bin/compare_csv.py sd-92569:work/z24274262/
#   bin/capture.sh rapports/zenodo-24274262/compare.log 'cd ~/work/z24274262 && sh compare.sh'
# Livré = data/derived/{tables,figures} (archive Zenodo 23799274) ; régénéré = run_mtime/results/{tables,figures}.
#  - .parquet : converti en CSV (parquet_vers_csv.py, dans le conteneur), puis bin/compare_csv.py, exact puis rtol 1e-9 ;
#  - .tex et .pdf : octet par octet (cmp).
cd ~/work/z24274262 || exit 1
rm -rf cmp && mkdir -p cmp/livre cmp/regenere cmp/livre_trie cmp/regenere_trie
D="-v $PWD:/w:rw -w /w -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1"
O="--rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
podman run $O $D localhost/replab-shadow /app/.venv/bin/python -I parquet_vers_csv.py data/derived/tables cmp/livre cmp/livre_trie
podman run $O $D localhost/replab-shadow /app/.venv/bin/python -I parquet_vers_csv.py run_mtime/results/tables cmp/regenere cmp/regenere_trie
echo "=== jeux de fichiers (livré seulement / régénéré seulement)"
(cd data/derived/tables && ls) > cmp/l_tables.txt
(cd run_mtime/results/tables && ls) > cmp/r_tables.txt
diff cmp/l_tables.txt cmp/r_tables.txt && echo "tables : mêmes fichiers"
(cd data/derived/figures && ls) > cmp/l_fig.txt
(cd run_mtime/results/figures && ls) > cmp/r_fig.txt
diff cmp/l_fig.txt cmp/r_fig.txt && echo "figures : mêmes fichiers"
for f in $(ls cmp/livre); do
  echo "== CSV $f : exact"
  python3 -I compare_csv.py cmp/livre/$f cmp/regenere/$f | tail -6
  echo "== CSV $f : rtol 1e-9"
  python3 -I compare_csv.py --rtol 1e-9 cmp/livre/$f cmp/regenere/$f | tail -2
done
echo "=== DIAGNOSTIC SÉPARÉ : lignes triées sur les 4 premières colonnes, sans les colonnes p_holm_without_hypervolume et significant_without_hypervolume"
for f in $(ls cmp/livre_trie | grep _stats); do
  echo "== CSV trié $f : exact"
  python3 -I compare_csv.py cmp/livre_trie/$f cmp/regenere_trie/$f | tail -6
  echo "== CSV trié $f : rtol 1e-9"
  python3 -I compare_csv.py --rtol 1e-9 cmp/livre_trie/$f cmp/regenere_trie/$f | tail -2
done
for f in $(ls data/derived/tables | grep '\.tex$'); do
  if cmp data/derived/tables/$f run_mtime/results/tables/$f; then echo "== TEX $f : identique (cmp)"; else echo "== TEX $f : DIFFERE (cmp)"; fi
done
n=0; d=0
for f in $(ls run_mtime/results/figures | grep '\.pdf$'); do
  n=$((n+1))
  if cmp -s data/derived/figures/$f run_mtime/results/figures/$f; then :; else d=$((d+1)); echo "PDF différent (cmp) : $f"; fi
done
echo "== PDF régénérés : $n ; différents à l'octet : $d"
