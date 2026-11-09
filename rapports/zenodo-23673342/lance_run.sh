#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) ; attend la ligne FIN de telechargement_ibge.log :
#   scp rapports/zenodo-23673342/lance_run.sh sd-92569:work/z23673342/
#   bin/lance_detache.sh work/z23673342 lance_run.sh run_full.log
# Suit « Rebuild the main application from public census inputs » : Rscript run_all.R (étapes 01 à 08, 10, 11 ;
# l'étape 09 saute faute de fichiers SPSS). Le paquet est copié dans run_full/ (inscriptible) ; l'original reste intact
# dans pkg/. Les microdonnées téléchargées par curl (raw/) sont montées en lecture seule. Image replab-bodmpi,
# sans réseau, sans capacité, racine en lecture seule ; durée bornée à 6 h (timeout hôte).
until grep -q '^FIN' telechargement_ibge.log; do sleep 30; done
grep -c ' code=0' telechargement_ibge.log
rm -rf run_full
mkdir run_full
cp -a pkg/. run_full/
date -u +%Y-%m-%dT%H:%M:%SZ
t0=$(date +%s)
timeout 21600 podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run_full:/work:rw" -v "$PWD/raw:/raw:ro" -w /work -e HOME=/tmp \
  -e BOD_CENSUS2010_DIR=/raw/census2010 -e BOD_CENSUS2022_ZIP=/raw/census2022/Todas_as_UFs.zip \
  localhost/replab-bodmpi Rscript run_all.R
echo "code run_all.R : $?"
echo "durée (s) : $(( $(date +%s) - t0 ))"
date -u +%Y-%m-%dT%H:%M:%SZ
echo FIN
