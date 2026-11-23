#!/bin/bash
# bin/liste_zenodo_rel.sh <fichier capture.sh> : lance liste_zenodo_rel.py en mode isolé (python3 -I).
exec python3 -I "$(dirname "$0")/liste_zenodo_rel.py" "$1"
