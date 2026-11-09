#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23652337/lance_figures.sh rapports/zenodo-23652337/compare_cache.py sd-92569:work/z23652337/
#   bin/capture.sh rapports/zenodo-23652337/figures.log 'cd ~/work/z23652337 && sh lance_figures.sh'
# Suit la section « Figures » du README (cd code && python3 make_figures.py) APRÈS suppression du cache fig_cache.npz
# livré, pour que la fonction de profit soit recalculée. Copie dans fig/ (l'original reste dans pkg/), image replab-reach,
# sans réseau, sans capacité ; borne 50 min. Puis comparaison du cache recalculé au cache livré (compare_cache.py).
rm -rf fig && mkdir fig
cp -a pkg/replication_package/. fig/
rm fig/figures/fig_cache.npz
date -u +%Y-%m-%dT%H:%M:%SZ
t0=$(date +%s)
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/fig:/work:rw" -w /work/code -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-reach timeout 3000 python3 make_figures.py
echo "code make_figures : $?"
echo "durée (s) : $(( $(date +%s) - t0 ))"
ls -l fig/figures
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/fig:/new:ro" -v "$PWD/pkg/replication_package:/old:ro" -v "$PWD/compare_cache.py:/c.py:ro" \
  -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-reach python3 -I /c.py /old/figures/fig_cache.npz /new/figures/fig_cache.npz
echo "code compare_cache : $?"
