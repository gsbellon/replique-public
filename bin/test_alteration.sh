#!/usr/bin/env bash
# Test d'altération du registre (CLAUDE.md art. 7). Travaille sur une copie hors de l'arbre ; le dépôt n'est jamais modifié.
#   bash bin/test_alteration.sh
# Trois falsifications, chacune doit faire échouer `registre.sh verifie` ; la copie intacte doit passer.
set -uo pipefail
src="$(cd "$(dirname "$0")/.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
ko=0

frais() { # frais <nom> : copie neuve dans $tmp/<nom>
  mkdir -p "$tmp/$1"
  cp -r "$src/bin" "$tmp/$1/"
  cp -r "$src/registre" "$tmp/$1/"
  cp -r "$src/rapports" "$tmp/$1/"
}
attend() { # attend <nom> <échec|succès> <description>
  if bash "$tmp/$1/bin/registre.sh" verifie > "$tmp/$1.out" 2>&1; then r=succès; else r=échec; fi
  if [ "$r" = "$2" ]; then echo "PASSE  $3 (verifie: $r)"; else echo "ECHEC  $3 (attendu $2, obtenu $r)"; ko=1; fi
  sed 's/^/        /' "$tmp/$1.out"
}

frais intact
attend intact succès "copie intacte"

frais fichier
cible=$(cut -f4 "$src/registre/chaine.tsv" | tail -n1)
printf 'altération\n' >> "$tmp/fichier/$cible"
attend fichier échec "fichier inscrit modifié ($cible)"

frais ligne
sed -i '3s/^\([^\t]*\t\)[^\t]*/\11999-01-01T00:00:00Z/' "$tmp/ligne/registre/chaine.tsv"
attend ligne échec "date de l'entrée 3 réécrite"

frais retrait
sed -i '4d' "$tmp/retrait/registre/chaine.tsv"
attend retrait échec "entrée 4 supprimée"

[ $ko = 0 ] && echo "TOUT PASSE" || echo "AU MOINS UN ECHEC"
exit $ko
