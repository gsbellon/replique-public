#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24141273/compare.sh bin/compare_csv.py sd-92569:work/z24141273/
#   bin/capture.sh rapports/zenodo-24141273/compare2.log 'cd ~/work/z24141273 && sh compare.sh'
# (compare.log = première version du script, dont le filtre « RESULTAT: identique » ne reconnaissait pas le suffixe
#  « (atol=…) » : son récapitulatif « identiques : 0 » est faux ; seul compare2.log fait foi pour les décomptes.)
# Compare les sorties livrées (pkg/.../output) aux sorties régénérées (run/output) :
#  1. listes de fichiers (présents d'un côté seulement) ;
#  2. chaque CSV de output/tables par le comparateur commun bin/compare_csv.py (égalité exacte, atol=rtol=0) ;
#  3. chaque autre fichier (JSON de results, notes, PNG) octet par octet (cmp) ;
#  4. récapitulatif.
cd ~/work/z24141273 || exit 1
R=pkg/replication_package_v1.0.1/output
N=run2/output   # régénéré par lance_run_corrige.sh (le run/ de lance_run.sh a échoué à l'étape 20)
echo "== fichiers livrés seulement / régénérés seulement (diff des listes)"
(cd "$R" && find . -type f | sort) > /tmp/liste_ref.txt
(cd "$N" && find . -type f | sort) > /tmp/liste_new.txt
diff /tmp/liste_ref.txt /tmp/liste_new.txt
echo "code diff listes : $?"
echo "== CSV : compare_csv.py"
nc=0; ok=0; ko=0
for f in $(grep '\.csv$' /tmp/liste_ref.txt); do
  nc=$((nc+1))
  out=$(python3 -I compare_csv.py "$R/$f" "$N/$f" 2>&1)
  last=$(echo "$out" | tail -1)
  case "$last" in
    "RESULTAT: identique"*) ok=$((ok+1)); echo "IDENTIQUE $f" ;;
    *) ko=$((ko+1)); echo "DIFFERE   $f"; echo "$out" | head -12 ;;
  esac
done
echo "CSV comparés : $nc ; identiques : $ok ; différents : $ko"
echo "== autres fichiers : cmp"
nf=0; oka=0; kob=0
for f in $(grep -v '\.csv$' /tmp/liste_ref.txt); do
  nf=$((nf+1))
  if cmp -s "$R/$f" "$N/$f"; then oka=$((oka+1)); else kob=$((kob+1)); echo "DIFFERE (octets) $f"; fi
done
echo "autres fichiers comparés : $nf ; identiques : $oka ; différents : $kob"
