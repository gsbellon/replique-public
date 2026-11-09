#!/bin/bash
# bin/compte_lignes.sh <fichier> <motif> <fichier de sortie>
# Compte les lignes de <fichier> qui correspondent au motif (grep -c) et enregistre
# la commande, le compte et le code dans <fichier de sortie>.
set -u
IN="$1"; PAT="$2"; OUT="$3"
{
  echo "# commande : grep -c \"$PAT\" $IN"
  grep -c -- "$PAT" "$IN"
  echo "# code de sortie : $?"
} > "$OUT"
cat "$OUT"
