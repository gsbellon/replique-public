#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/lance_later.sh sd-92569:work/z23637733/
#   bin/capture.sh rapports/zenodo-23637733/later.log 'cd ~/work/z23637733 && sh lance_later.sh'
# Le README ne cite pas la commande qui écrit results/instrumentation_asymmetry_copilot_later_window.csv. Le script
# (run_instrumentation_asymmetry.py, lignes 15-16) prend en arguments le snapshot et l'étiquette ; on les déduit
# de ses noms de fichiers : ce n'est PAS une commande du README. Copie neuve run4/, fichier supprimé avant.
rm -rf run4 && mkdir run4 && cp -a pkg/replication_package/. run4/
rm -f run4/results/instrumentation_asymmetry_copilot_later_window.csv
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v "$PWD/run4:/work:rw" -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-evid timeout 600 \
  python3 simulation/run_instrumentation_asymmetry.py results_holdout/public_prs_copilot_agent_holdout.json copilot_later_window
echo "code de sortie : $?"
cmp pkg/replication_package/results/instrumentation_asymmetry_copilot_later_window.csv run4/results/instrumentation_asymmetry_copilot_later_window.csv && echo "identique au livré"
diff -rq pkg/replication_package run4
