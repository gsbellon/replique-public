#!/bin/sh
# Seconde exécution (répétabilité), même image, mêmes entrées que lance_run.sh ; le répertoire run/ de la 1re exécution est conservé.
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/lance_run2.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/lancement_run2.log 'cd ~/work/z23585246 && sh lance_run2.sh'
# Le VIX n'est PAS retéléchargé : on réutilise le fichier de la 1re exécution (sinon les entrées différeraient).
# Conteneur détaché replab-oilecu-run2 ; résultats dans ~/work/z23585246/run2/.
rm -rf run2 && mkdir run2
cp -a pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/. run2/
cp run/data/raw/FRED_VIXCLS.csv run2/data/raw/FRED_VIXCLS.csv
sha256sum run/data/raw/FRED_VIXCLS.csv run2/data/raw/FRED_VIXCLS.csv
podman rm -f replab-oilecu-run2 2>/dev/null
podman run -d --name replab-oilecu-run2 --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run2:/work:rw" -w /work -e SKIP_DOWNLOAD=1 -e PY=python3 -e HOME=/tmp \
  replab-oilecu bash run_all.sh
date -u +%Y-%m-%dT%H:%M:%SZ
podman ps -a
