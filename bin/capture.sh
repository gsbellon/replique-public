#!/bin/bash
# bin/capture.sh <fichier local de sortie> <commande à exécuter sur sd-92569>
# Exécute la commande sur l'exécuteur et enregistre dans le fichier : la commande, la date,
# la sortie complète (stdout+stderr), le code de sortie et la durée. Rien n'est recopié à la main.
set -u
OUT="$1"; shift
mkdir -p "$(dirname "$OUT")"
{
  echo "# commande : ssh sd-92569 $*"
  echo "# début    : $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "# ----"
  START=$(date +%s)
  ssh sd-92569 "$@" 2>&1
  RC=$?
  END=$(date +%s)
  echo "# ----"
  echo "# code de sortie : $RC"
  echo "# durée (s)      : $((END-START))"
} > "$OUT"
tail -3 "$OUT"
