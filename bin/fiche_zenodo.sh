#!/bin/bash
# bin/fiche_zenodo.sh <fichier capture.sh> <id>... : lance fiche_zenodo.py en mode isolé (python3 -I).
exec python3 -I "$(dirname "$0")/fiche_zenodo.py" "$@"
