#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/lance_run.sh sd-92569:work/z24274262/
#   bin/capture.sh rapports/zenodo-24274262/run.log 'cd ~/work/z24274262 && sh lance_run.sh'
# Commande documentée par le README du paquet (« From the derived data alone ») :
#   uv run snakemake --cores 8 --config from_summaries=true
# Ici : le paquet est copié dans run/, les données dérivées de la fiche 23799274 (data/derived, extraites par
# telecharge_derived.sh) dans run/results/ avec leurs dates de modification (cp -a), SAUF tables/ et figures/ qui
# sont ce que la réexécution doit régénérer. L'original reste intact dans pkg/ et data/derived/.
# Image replab-shadow, sans réseau, sans capacité, racine en lecture seule ; l'environnement /app/.venv de l'image
# remplace « uv run » (même environnement, verrou uv.lock).
P=pkg/gialmisi-shadow-price-experiments-22691ed
rm -rf run && mkdir run
cp -a $P/. run/
mkdir run/results
for d in summary reference thresholds timing; do cp -a data/derived/$d run/results/$d; done
date -u +%Y-%m-%dT%H:%M:%SZ
echo "=================== snakemake -n (simulation)"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PATH=/app/.venv/bin:/usr/local/bin:/usr/bin:/bin -e VIRTUAL_ENV=/app/.venv -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-shadow timeout 1800 /app/.venv/bin/snakemake -n --cores 4 --config from_summaries=true 2>&1 | tail -4
echo "=================== snakemake (exécution)"
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e PATH=/app/.venv/bin:/usr/local/bin:/usr/bin:/bin -e VIRTUAL_ENV=/app/.venv -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-shadow timeout 3000 /app/.venv/bin/snakemake --cores 4 --config from_summaries=true > run_snakemake.out 2>&1
echo "code snakemake : $?"
echo "durée (s) : $(( $(date +%s) - t0 ))"
tail -40 run_snakemake.out
echo "=================== règles en erreur et première cause relevée (lignes tronquées à 220 caractères)"
grep "^Error in rule" run_snakemake.out
grep -m4 "reason:" run_snakemake.out | cut -c1-220
grep -m2 "provenance" run_snakemake.out | cut -c1-220
echo "=================== fichiers de results/ après exécution"
find run/results -newer run/Snakefile -type f | wc -l
ls run/results/tables | wc -l
ls run/results/figures | wc -l
