#!/bin/bash
# bin/fiche_meta.sh <notice.json>... : lance fiche_meta.py en mode isolé (python3 -I) sur chaque notice.
for f in "$@"; do
  echo "===== $f"
  python3 -I "$(dirname "$0")/fiche_meta.py" "$f"
done
