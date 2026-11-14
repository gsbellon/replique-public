#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24218418/lance_run.sh sd-92569:work/z24218418/
#   bin/capture.sh rapports/zenodo-24218418/run.log 'cd ~/work/z24218418 && sh lance_run.sh'
# Le README ne documente aucune commande ; les scripts de code/ qui ne lisent que resultados/ (cifras_manuscrito.py,
# extras_manuscrito.py, sensibilidad_paso.py, figura1.py) sont lancés dans l'ordre de leurs dépendances de fichiers
# (cifras -> consensos_polis_tipados.csv -> extras / sensibilidad -> tipologia_por_conversacion.csv -> figura1),
# avec l'argument « resultados » du paquet (valeur par défaut des scripts). Le paquet est copié dans run/ ; l'original
# reste intact dans pkg/. Image replab-polis, sans réseau, sans capacité, racine en lecture seule ; chaque étape bornée à 30 min.
rm -rf run && mkdir run
cp -a pkg/. run/
mkdir -p run/figuras
date -u +%Y-%m-%dT%H:%M:%SZ
for s in cifras_manuscrito extras_manuscrito sensibilidad_paso; do
  echo "=================== étape $s.py resultados"
  t0=$(date +%s)
  podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
    -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
    localhost/replab-polis timeout 1800 python3 code/$s.py resultados > "run_$s.out" 2>&1
  echo "code $s : $?"
  echo "durée (s) : $(( $(date +%s) - t0 ))"
  tail -c 300 "run_$s.out"
done
echo "=================== étape figura1.py resultados figuras"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp \
  -v "$PWD/run:/work:rw" -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 \
  localhost/replab-polis timeout 1800 python3 code/figura1.py resultados figuras
echo "code figura1 : $?"
echo "=================== fichiers modifiés par rapport à pkg/"
diff -rq pkg run
