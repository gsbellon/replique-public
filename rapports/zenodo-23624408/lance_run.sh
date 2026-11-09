#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/lance_run.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/run_all.log 'cd ~/work/z23624408 && sh lance_run.sh'
# Prérequis : pkg/ (extraction.log), raw/ (telechargement_ibge.log), image replab-deamph (build.log).
# La commande du paquet est `Rscript run_all.R` (README, "Running") : toutes les étapes 01 à 09, puis tests/check_results.R.
# Conteneur sans réseau : l'étape 01 ne télécharge rien car les fichiers sont déjà là (voir telecharge_ibge.sh) ;
# elle calcule les SHA-256 des entrées. Le paquet est monté en lecture seule ; sorties et fichiers intermédiaires
# vont dans out/ et work/ (répertoires neufs), via les variables d'environnement documentées dans le README.
OPTS="--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
rm -rf out work && mkdir out work
podman run --rm $OPTS \
  -v "$PWD/pkg:/pkg:ro" -v "$PWD/raw:/raw:ro" -v "$PWD/out:/out" -v "$PWD/work:/work" -w /pkg \
  -e DEAMPH_CENSUS2010_DIR=/raw/census2010 -e DEAMPH_CENSUS2022_ZIP=/raw/census2022/Todas_as_UFs.zip \
  -e DEAMPH_WORK_DIR=/work -e DEAMPH_OUTPUT_DIR=/out \
  replab-deamph Rscript run_all.R
echo "code de sortie run_all : $?"
