#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23735615/lance_hors_paquet.sh sd-92569:work/z23735615/
#   bin/capture.sh rapports/zenodo-23735615/hors_paquet.log 'cd ~/work/z23735615 && sh lance_hors_paquet.sh'
# Section « Hors paquet » : deux corrections minimales à la commande/l'environnement, absentes du paquet livré.
#  (1) `requests` (importé par tests/test_hermetic_ci.py, absent de REPLICATION.md) : image dérivée, pip install requests
#      (réseau à la construction seulement).
#  (2) generate_paper_artifacts.py fixe PROJECT_ROOT = Path(r"F:\论文\llm-test-stability") (chemin Windows de l'auteur) :
#      sous Linux c'est un chemin relatif d'un seul composant ; correction = un lien symbolique de ce nom vers « . »
#      dans la copie (ln -s . 'run2/F:\论文\llm-test-stability'). Aucune ligne du paquet n'est modifiée.
# Copie fraîche du paquet dans run2/ ; l'original reste intact dans pkg/.
rm -rf build2 && mkdir build2
printf 'FROM localhost/replab-quarantine\nRUN pip install --no-cache-dir requests\n' > build2/Containerfile
podman build -t replab-quarantine-req -f build2/Containerfile build2
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only localhost/replab-quarantine-req python3 -c 'import requests; print(requests.__version__)'
rm -rf run2 && mkdir run2
cp -a pkg/*/. run2/
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run2:/work:rw -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-quarantine-req timeout 1500"
etape() {
  echo "=================== ETAPE $*"
  s=$(date +%s)
  $P "$@"
  echo "code de sortie : $?  (durée $(( $(date +%s) - s )) s)"
}
etape python3 -m pytest tests/ -v -p no:cacheprovider
ln -s . 'run2/F:\论文\llm-test-stability'
ls -l run2 | grep llm-test-stability
etape python3 scripts/generate_paper_artifacts.py --run-id run_phase4_rerun_20260926_090500
echo "=================== fichiers modifiés ou créés par rapport au livré"
diff -rq --no-dereference pkg/*/ run2/
