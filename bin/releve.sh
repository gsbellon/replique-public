#!/bin/bash
# bin/releve.sh [--essai] : relève de la boîte du projet (bin/releve.py, article 4), depuis ~/replique.
cd "$HOME/replique" || exit 2
exec python3 -I bin/releve.py "$@"
