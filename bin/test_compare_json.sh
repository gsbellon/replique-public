#!/usr/bin/env bash
# Valide bin/compare_json.py sur des cas connus (CLAUDE.md art. 5 bis).
#   bash bin/test_compare_json.sh
# Chaque cas : référence, nouveau, options, code attendu (0 identique, 1 diffère, 2 usage). Aucun accès réseau.
set -uo pipefail
src="$(cd "$(dirname "$0")" && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
ko=0

ecrit() { printf '%s' "$2" > "$tmp/$1"; }
cas() { # cas <description> <attendu> <réf> <nouveau> [options...]
  local desc="$1" att="$2" r="$3" n="$4"; shift 4
  python3 -I "$src/compare_json.py" "$@" "$tmp/$r" "$tmp/$n" > "$tmp/out" 2>&1
  local rc=$?
  if [ "$rc" = "$att" ]; then echo "PASSE  $desc (code $rc)"; else echo "ECHEC  $desc (attendu $att, obtenu $rc)"; sed 's/^/        /' "$tmp/out"; ko=1; fi
}

ecrit ref '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
ecrit meme '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
cas "fichiers identiques" 0 ref meme
ecrit ordre_cles '{"g": true, "f": null, "d": [1, 2, {"e": 0}], "c": "x", "b": 2.5, "a": 1}'
cas "ordre des clés indifférent" 0 ref ordre_cles
ecrit espaces '{ "a":1,"b":2.5,"c":"x","d":[1,2,{"e":0}],"f":null,"g":true }'
cas "mise en forme indifférente" 0 ref espaces

cas "fichier nouveau manquant" 1 ref inexistant
cas "fichier référence manquant" 1 inexistant ref
ecrit vide ''
cas "nouveau vide" 1 ref vide
ecrit invalide '{"a": 1,'
cas "JSON invalide" 1 ref invalide

ecrit cle_manque '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null}'
cas "clé manquante" 1 ref cle_manque
ecrit cle_trop '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true, "h": 0}'
cas "clé en trop" 1 ref cle_trop
ecrit cle_profonde '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"z": 0}], "f": null, "g": true}'
cas "clé renommée en profondeur" 1 ref cle_profonde
ecrit liste_courte '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2], "f": null, "g": true}'
cas "liste plus courte" 1 ref liste_courte
ecrit liste_longue '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}, 4], "f": null, "g": true}'
cas "liste plus longue" 1 ref liste_longue
ecrit liste_ordre '{"a": 1, "b": 2.5, "c": "x", "d": [2, 1, {"e": 0}], "f": null, "g": true}'
cas "ordre d'une liste compte" 1 ref liste_ordre

ecrit texte '{"a": 1, "b": 2.5, "c": "X", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
cas "chaîne différente" 1 ref texte
ecrit type_chaine '{"a": "1", "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
cas "nombre contre chaîne" 1 ref type_chaine
ecrit type_null '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": 0, "g": true}'
cas "null contre nombre" 1 ref type_null
ecrit type_bool '{"a": 1, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": 1}'
cas "booléen contre nombre, tolérance large" 1 ref type_bool --atol 10
ecrit type_liste '{"a": 1, "b": 2.5, "c": "x", "d": {"0": 1}, "f": null, "g": true}'
cas "liste contre objet" 1 ref type_liste

ecrit cellule '{"a": 1, "b": 2.5001, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
cas "écart numérique, tolérance nulle" 1 ref cellule
cas "écart dans atol" 0 ref cellule --atol 0.001
cas "écart hors atol" 1 ref cellule --atol 0.00001
cas "écart dans rtol" 0 ref cellule --rtol 0.0001
cas "écart hors rtol" 1 ref cellule --rtol 0.000001
ecrit entier_flottant '{"a": 1.0, "b": 2.5, "c": "x", "d": [1, 2, {"e": 0}], "f": null, "g": true}'
cas "1 et 1.0" 0 ref entier_flottant

# zéros : réf nulle, écart minuscule ; rtol seul ne doit rien tolérer, sans division par zéro
ecrit zero_ref '{"v": 0}'
ecrit zero_eps '{"v": 1e-12}'
cas "réf nulle, rtol seul ne tolère pas" 1 zero_ref zero_eps --rtol 0.5
cas "réf nulle, atol tolère" 0 zero_ref zero_eps --atol 1e-9
ecrit zero_neg '{"v": -0.0}'
cas "0 et -0.0" 0 zero_ref zero_neg

# grands entiers : pas d'arrondi en flottant à tolérance nulle
ecrit grand1 '{"v": 9007199254740993}'
ecrit grand2 '{"v": 9007199254740992}'
cas "grands entiers voisins" 1 grand1 grand2

# NaN et infinis (JSON étendu, tel que l'écrivent Python et numpy)
ecrit nan '{"v": NaN}'
ecrit un '{"v": 1}'
cas "NaN contre NaN" 0 nan nan
cas "NaN contre nombre" 1 nan un
cas "nombre contre NaN" 1 un nan
ecrit inf '{"v": Infinity}'
ecrit minf '{"v": -Infinity}'
cas "inf contre inf" 0 inf inf
cas "inf contre -inf" 1 inf minf
cas "inf contre fini, tolérance large" 1 inf un --atol 1e308 --rtol 1
cas "fini contre inf, tolérance large" 1 un inf --atol 1e308 --rtol 1

# racine qui n'est pas un objet
ecrit racine_liste '[1, 2, 3]'
ecrit racine_liste2 '[1, 2, 4]'
cas "racine liste identique" 0 racine_liste racine_liste
cas "racine liste différente" 1 racine_liste racine_liste2
cas "racine liste contre objet" 1 racine_liste ref

# BOM en tête : même contenu
printf '\357\273\277{"v": 1}' > "$tmp/bom"
cas "BOM, même contenu" 0 un bom

# tolérance invalide : erreur d'usage (code 2)
cas "tolérance négative" 2 ref meme --atol -1

[ $ko = 0 ] && echo "TOUT PASSE" || echo "AU MOINS UN ECHEC"
exit $ko
