#!/bin/bash
# bin/range_exploration.sh <dossier de recherche> <dossier de paquet écarté>... :
# déplace des dossiers de paquets examinés puis écartés (hors périmètre de l'article 1, aucun rapport) sous le dossier
# de recherche de la session, pour qu'ils ne passent pas pour des rapports. Ne touche qu'à rapports/ ; n'exécute rien de tiers.
set -eu
cd "$(dirname "$0")/.."
DEST="$1"; shift
case "$DEST" in rapports/zenodo-recherche-*) ;; *) echo "destination refusée : $DEST"; exit 2;; esac
for d in "$@"; do
  case "$d" in rapports/zenodo-[0-9]*) ;; *) echo "refusé : $d"; exit 2;; esac
  [ -e "$d/RAPPORT.md" ] && { echo "refusé (a un RAPPORT.md) : $d"; exit 2; }
  mv "$d" "$DEST/"
  echo "déplacé : $d -> $DEST/"
done
