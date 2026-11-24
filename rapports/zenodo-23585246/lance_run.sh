#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585246/lance_run.sh sd-92569:work/z23585246/
#   bin/capture.sh rapports/zenodo-23585246/lancement.log 'cd ~/work/z23585246 && sh lance_run.sh'
# Prérequis : pkg/ (extraction.log), image replab-oilecu (build.log). Durée prévue ~2 h : conteneur DÉTACHÉ (podman run -d),
# nom replab-oilecu-run ; sortie = `podman logs replab-oilecu-run`, code = `podman wait`, résultats dans ~/work/z23585246/run/.
# Le VIX (non redistribué) est téléchargé sur l'hôte par curl seulement (même URL que src/01_fetch_fred.py) ; le conteneur n'a aucun réseau
# (SKIP_DOWNLOAD=1 saute les étapes 00 et 01 du paquet, comme le prévoit run_all.sh). Le paquet est copié dans run/ (inscriptible) car
# ses scripts écrivent sous data/processed, output/ et paper/_tables.
rm -rf run && mkdir run
cp -a pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/. run/
# --http1.1 : le premier essai en HTTP/2 a échoué (curl 92, lancement.log) ; sans agent utilisateur personnalisé : avec
# « -A research-script » la requête GET restait sans réponse (lancement_2.log, test_fred_get.log), sans lui elle aboutit (test_fred_get3.log) ; on n'enchaîne pas si le téléchargement échoue.
curl -sS -f --http1.1 --retry 3 -m 120 -o run/data/raw/FRED_VIXCLS.csv "https://fred.stlouisfed.org/graph/fredgraph.csv?id=VIXCLS" || { echo "ECHEC curl VIX : $?"; exit 1; }
echo "curl VIX ok"
# FRED sert désormais l'en-tête « observation_date,VIXCLS » ; src/01_fetch_fred.py (fetch) renomme les colonnes en « date,VIXCLS » avant
# d'écrire le fichier, et 02_build_dataset.py lit « date » (échec du 1er lancement : etat_2.log). Même mise en forme ici (vix_forme.log : pas de « . »).
sed -i '1s/.*/date,VIXCLS/' run/data/raw/FRED_VIXCLS.csv
head -n 2 run/data/raw/FRED_VIXCLS.csv
sha256sum run/data/raw/FRED_VIXCLS.csv
tail -n 2 run/data/raw/FRED_VIXCLS.csv
podman rm -f replab-oilecu-run 2>/dev/null
podman run -d --name replab-oilecu-run --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e SKIP_DOWNLOAD=1 -e PY=python3 -e HOME=/tmp \
  replab-oilecu bash run_all.sh
date -u +%Y-%m-%dT%H:%M:%SZ
podman ps -a
