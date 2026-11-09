#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23833498/lance_run.sh sd-92569:work/z23833498/
#   bin/capture.sh rapports/zenodo-23833498/run.log 'cd ~/work/z23833498 && sh lance_run.sh'
# Suit REPRODUCIBILITY.md et le Makefile du paquet : `make all` puis `make verify`. Pas de make dans l'image :
# les recettes du Makefile sont exécutées dans le même ordre (results, figures avec les mv, verify.py une fois).
# `make verify` relancerait `results` ; verify.py lit les JSON régénérés par `make all`, on ne les régénère pas deux fois (écart noté au rapport).
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/. Image replab-granularity, sans réseau,
# sans capacité, racine en lecture seule ; chaque étape bornée à 50 min (timeout).
rm -rf run && mkdir run
cp -a pkg/. run/
etape() {
  echo "=================== $*"
  date -u +%Y-%m-%dT%H:%M:%SZ
  t0=$(date +%s)
  podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
    -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
    localhost/replab-granularity timeout 3000 "$@"
  echo "code $* : $?"
  echo "durée $* (s) : $(( $(date +%s) - t0 ))"
}
etape python3 archetypes.py
etape python3 extended_analyses.py
etape python3 robustness_analyses.py
etape python3 archetype_figures.py
etape python3 extended_figures.py
etape sh -c 'mkdir -p figures && mv -f f1_states.png figures/Figure_1.png && mv -f f2_premium.png figures/Figure_2.png && mv -f f3_optimum.png figures/Figure_3.png && mv -f Figure_4.png figures/Figure_4.png && mv -f f5_mechanisms.png figures/Figure_5.png && mv -f f6_scale.png figures/Figure_6.png && mv -f Figure_7.png figures/Figure_7.png && mv -f Figure_8.png figures/Figure_8.png && rm -f f4_tornado.png'
etape python3 verify.py
echo "=================== fichiers produits dans run/ et run/figures/"
ls -l run run/figures
