#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/lance_run_mtime.sh sd-92569:work/z24274262/
#   bin/capture.sh rapports/zenodo-24274262/run_mtime.log 'cd ~/work/z24274262 && sh lance_run_mtime.sh'
# Variante « Hors paquet » de lance_run.sh : même préparation (run_mtime/ = copie du paquet + données dérivées sans
# tables/ ni figures/), même image et mêmes options de conteneur ; seule différence : la commande Snakemake reçoit
# --rerun-triggers mtime, option que scripts/fetch_data.py du paquet emploie lui-même pour son contrôle (ligne « cmd »).
P=pkg/gialmisi-shadow-price-experiments-22691ed
rm -rf run_mtime && mkdir run_mtime
cp -a $P/. run_mtime/
mkdir run_mtime/results
for d in summary reference thresholds timing; do cp -a data/derived/$d run_mtime/results/$d; done
date -u +%Y-%m-%dT%H:%M:%SZ
echo "=================== snakemake -n --rerun-triggers mtime (simulation)"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run_mtime:/work:rw" -w /work -e HOME=/tmp -e PATH=/app/.venv/bin:/usr/local/bin:/usr/bin:/bin -e VIRTUAL_ENV=/app/.venv -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-shadow timeout 1800 /app/.venv/bin/snakemake -n --quiet rules --cores 4 --rerun-triggers mtime --config from_summaries=true
echo "=================== snakemake --rerun-triggers mtime (exécution)"
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run_mtime:/work:rw" -w /work -e HOME=/tmp -e PATH=/app/.venv/bin:/usr/local/bin:/usr/bin:/bin -e VIRTUAL_ENV=/app/.venv -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-shadow timeout 3000 /app/.venv/bin/snakemake --cores 4 --rerun-triggers mtime --config from_summaries=true > run_mtime_snakemake.out 2>&1
echo "code snakemake : $?"
echo "durée (s) : $(( $(date +%s) - t0 ))"
tail -8 run_mtime_snakemake.out
echo "=================== fichiers régénérés"
ls run_mtime/results/tables | wc -l
ls run_mtime/results/figures | wc -l
