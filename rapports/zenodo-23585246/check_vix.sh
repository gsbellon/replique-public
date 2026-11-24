#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/check_vix.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/check_vix.log 'cd ~/work/z23585246 && sh check_vix.sh'
# Appelle check_vix() de src/01_fetch_fred.py (empreinte SHA-256 des valeurs du VIX jusqu'au 2026-09-22) sur le fichier téléchargé,
# en conteneur sans réseau, paquet en lecture seule. Le module est importé (main() n'est pas appelé).
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:ro" -w /work -e PYTHONDONTWRITEBYTECODE=1 replab-oilecu \
  python3 -c 'import sys; sys.path.insert(0, "src"); import importlib; m = importlib.import_module("01_fetch_fred"); m.check_vix("data/raw/FRED_VIXCLS.csv")'
echo "code : $?"
