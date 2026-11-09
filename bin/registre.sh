#!/usr/bin/env bash
# Registre à chaînage de hachage (CLAUDE.md art. 7).
#   bin/registre.sh ajoute <type> <fichier>   ajoute une entrée (jamais de modification)
#   bin/registre.sh verifie                   vérifie la chaîne et les fichiers inscrits
#   bin/registre.sh tete                      imprime le hachage de tête (à témoigner)
# Format de registre/chaine.tsv : n, date UTC, type, chemin, sha256 du fichier, hachage précédent, hachage de l'entrée.
# Hachage de l'entrée = sha256 des six premiers champs joints par tabulation (sans saut de ligne final).
set -euo pipefail
cd "$(dirname "$0")/.."
CH=registre/chaine.tsv
ZERO=$(printf '0%.0s' $(seq 64))
h() { printf '%s' "$1" | sha256sum | cut -d' ' -f1; }
tete() { if [ -s "$CH" ]; then tail -n1 "$CH" | cut -f7; else echo "$ZERO"; fi; }
case "${1:-}" in
ajoute)
  type=$2; f=$3
  [ -f "$f" ] || { echo "fichier absent: $f" >&2; exit 2; }
  n=$(( $(wc -l < "$CH" 2>/dev/null || echo 0) + 1 ))
  prev=$(tete); d=$(date -u +%Y-%m-%dT%H:%M:%SZ); s=$(sha256sum "$f" | cut -d' ' -f1)
  corps=$(printf '%s\t%s\t%s\t%s\t%s\t%s' "$n" "$d" "$type" "$f" "$s" "$prev")
  printf '%s\t%s\n' "$corps" "$(h "$corps")" >> "$CH"
  tail -n1 "$CH" ;;
verifie)
  prev=$ZERO; n=0; mal=0
  # Seule la dernière inscription d'un chemin est comparée au fichier ; les précédentes restent dans la chaîne.
  derniere=$(cut -f4 "$CH" | awk '{d[$0]=NR} END{for(k in d) print d[k]"\t"k}')
  while IFS=$'\t' read -r i d t f s p e; do
    n=$((n+1))
    [ "$i" = "$n" ] || { echo "ENTRÉE $n: numéro $i"; mal=1; }
    [ "$p" = "$prev" ] || { echo "ENTRÉE $n: chaînage rompu"; mal=1; }
    c=$(printf '%s\t%s\t%s\t%s\t%s\t%s' "$i" "$d" "$t" "$f" "$s" "$p")
    [ "$(h "$c")" = "$e" ] || { echo "ENTRÉE $n: hachage invalide"; mal=1; }
    if ! printf '%s\n' "$derniere" | grep -qxF "$n$(printf '\t')$f"; then :
    elif [ -f "$f" ]; then
      [ "$(sha256sum "$f" | cut -d' ' -f1)" = "$s" ] || { echo "ENTRÉE $n: $f modifié depuis l'inscription"; mal=1; }
    else echo "ENTRÉE $n: $f absent"; mal=1; fi
    prev=$e
  done < "$CH"
  [ $mal = 0 ] && echo "OK: $n entrées, tête $prev"; exit $mal ;;
tete) tete ;;
*) echo "usage: $0 ajoute <type> <fichier> | verifie | tete" >&2; exit 2 ;;
esac
