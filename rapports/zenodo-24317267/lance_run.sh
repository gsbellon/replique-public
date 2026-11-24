#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24317267/lance_run.sh sd-92569:work/z24317267/
#   bin/capture.sh rapports/zenodo-24317267/run.log 'cd ~/work/z24317267 && sh lance_run.sh'
# Commande documentée du README (« Default run ») dans une copie du paquet : runA/. pkg/ reste intact (livré).
# Deux modifications, toutes deux documentées par le README : project_root dans 00_run_all.R, et type = "windows"
# -> "cairo" dans 03_figures_6_9.R (README p. 3 : « On macOS or Linux, change it to type = "cairo" »).
# Conteneur : sans réseau, sans capacité, racine en lecture seule, seul runA/ monté en écriture.
O="--rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp"
date -u +%Y-%m-%dT%H:%M:%SZ
rm -rf runA && mkdir runA
cp -a pkg/. runA/
# (pas d'ancre de fin de ligne : le premier essai, run.log, a échoué parce que les fins de ligne sont probablement CRLF)
sed -i 's|^project_root <- ".*"|project_root <- "/work"|' runA/code/00_run_all.R
sed -i 's|type = "windows"|type = "cairo"|' runA/code/03_figures_6_9.R
echo "=== modifications faites au code (diff pkg runA)"
diff -r pkg/code runA/code
echo "=== Rscript code/00_run_all.R (README : Source de 00_run_all.R)"
podman run $O -v $PWD/runA:/work:rw -w /work -e HOME=/tmp localhost/replab-blowcrawford timeout 3000 Rscript code/00_run_all.R
echo "code de sortie R : $?"
date -u +%Y-%m-%dT%H:%M:%SZ
