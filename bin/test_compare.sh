#!/usr/bin/env bash
# Valide bin/compare_csv.py sur des cas connus (CLAUDE.md art. 5 bis).
#   bash bin/test_compare.sh
# Chaque cas : référence, nouveau, options, code attendu (0 identique, 1 diffère). Aucun accès réseau.
set -uo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
ko=0

ecrit() { printf '%b' "$2" > "$tmp/$1"; }
cas() { # cas <description> <attendu> <réf> <nouveau> [options...]
  local desc="$1" att="$2" r="$3" n="$4"; shift 4
  python3 -I "$src/compare_csv.py" "$@" "$tmp/$r" "$tmp/$n" > "$tmp/out" 2>&1
  local rc=$?
  if [ "$rc" = "$att" ]; then echo "PASSE  $desc (code $rc)"; else echo "ECHEC  $desc (attendu $att, obtenu $rc)"; sed 's/^/        /' "$tmp/out"; ko=1; fi
}

ecrit ref 'a,b,c\n1,2.5,x\n0,0,y\n3,4,z\n'
ecrit meme 'a,b,c\n1,2.5,x\n0,0,y\n3,4,z\n'
cas "fichiers identiques" 0 ref meme

ecrit manque_col 'a,b\n1,2.5\n0,0\n3,4\n'
cas "colonne manquante" 1 ref manque_col
ecrit trop_col 'a,b,c,d\n1,2.5,x,1\n0,0,y,1\n3,4,z,1\n'
cas "colonne en trop" 1 ref trop_col
ecrit ordre 'b,a,c\n2.5,1,x\n0,0,y\n4,3,z\n'
cas "colonnes permutées" 1 ref ordre
cas "fichier nouveau manquant" 1 ref inexistant
cas "fichier référence manquant" 1 inexistant ref
ecrit vide ''
cas "nouveau vide" 1 ref vide
ecrit court 'a,b,c\n1,2.5,x\n0,0\n3,4,z\n'
cas "ligne plus courte" 1 ref court
ecrit moins 'a,b,c\n1,2.5,x\n0,0,y\n'
cas "moins de lignes" 1 ref moins
ecrit plus 'a,b,c\n1,2.5,x\n0,0,y\n3,4,z\n5,6,w\n'
cas "plus de lignes" 1 ref plus
ecrit texte 'a,b,c\n1,2.5,x\n0,0,Y\n3,4,z\n'
cas "texte différent" 1 ref texte
ecrit cellule 'a,b,c\n1,2.5001,x\n0,0,y\n3,4,z\n'
cas "écart numérique, tolérance nulle" 1 ref cellule
cas "écart dans atol" 0 ref cellule --atol 0.001
cas "écart hors atol" 1 ref cellule --atol 0.00001
cas "écart dans rtol" 0 ref cellule --rtol 0.0001
cas "écart hors rtol" 1 ref cellule --rtol 0.000001

# zéros : réf nulle, écart minuscule ; rtol seul ne doit rien tolérer, sans division par zéro
ecrit zero_ref 'a\n0\n'
ecrit zero_eps 'a\n1e-12\n'
cas "réf nulle, rtol seul ne tolère pas" 1 zero_ref zero_eps --rtol 0.5
cas "réf nulle, atol tolère" 0 zero_ref zero_eps --atol 1e-9
ecrit zero_neg 'a\n-0.0\n'
cas "0 et -0.0" 0 zero_ref zero_neg

# NaN et infinis
ecrit nan 'a\nnan\n'
ecrit nan2 'a\nNaN\n'
ecrit un 'a\n1\n'
cas "NaN contre NaN" 0 nan nan2
cas "NaN contre nombre" 1 nan un
cas "nombre contre NaN" 1 un nan
ecrit inf 'a\ninf\n'
ecrit inf2 'a\n+Infinity\n'
ecrit minf '-inf\n'
ecrit minf 'a\n-inf\n'
cas "inf contre inf" 0 inf inf2
cas "inf contre -inf" 1 inf minf
cas "inf contre fini, tolérance large" 1 inf un --atol 1e308 --rtol 1
cas "fini contre inf, tolérance large" 1 un inf --atol 1e308 --rtol 1

# cellule vide ou texte contre nombre
ecrit vide_cell 'a,b,c\n1,,x\n0,0,y\n3,4,z\n'
cas "cellule vide contre nombre" 1 ref vide_cell
ecrit nombre_texte 'a,b,c\n1,abc,x\n0,0,y\n3,4,z\n'
cas "texte contre nombre" 1 ref nombre_texte

# changement de structure : même nombre de colonnes, noms changés
ecrit renomme 'a,b,k\n1,2.5,x\n0,0,y\n3,4,z\n'
cas "colonne renommée" 1 ref renomme

# BOM et fins de ligne CRLF : même contenu
ecrit crlf 'a,b,c\r\n1,2.5,x\r\n0,0,y\r\n3,4,z\r\n'
cas "CRLF, même contenu" 0 ref crlf

# entêtes seuls
ecrit entete 'a,b,c\n'
cas "entêtes seuls identiques" 0 entete entete
cas "entêtes seuls contre données" 1 entete ref

# tolérance invalide : erreur d'usage (code 2)
cas "tolérance négative" 2 ref meme --atol -1

[ $ko = 0 ] && echo "TOUT PASSE" || echo "AU MOINS UN ECHEC"
exit $ko
