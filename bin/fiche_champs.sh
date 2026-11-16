#!/bin/bash
# bin/fiche_champs.sh <fiche_zenodo.json> : lance fiche_champs.py en mode isolé (python3 -I).
exec python3 -I "$(dirname "$0")/fiche_champs.py" "$@"
