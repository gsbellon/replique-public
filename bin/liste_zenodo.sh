#!/bin/bash
# bin/liste_zenodo.sh <fichier capture.sh> : lance liste_zenodo.py en mode isolé (python3 -I).
# Ne lit que du JSON ; n'exécute rien de tiers.
exec python3 -I "$(dirname "$0")/liste_zenodo.py" "$1"
