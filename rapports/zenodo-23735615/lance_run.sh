#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23735615/lance_run.sh rapports/zenodo-23735615/verifie_manifeste.py sd-92569:work/z23735615/
#   bin/capture.sh rapports/zenodo-23735615/run.log 'cd ~/work/z23735615 && sh lance_run.sh'
# Rejoue, hors réseau, les commandes de REPLICATION.md §2.2 à §2.4 et la vérification du manifeste du run
# d'autorité (SHA-256, §4). Non rejoués : §2.1 est tenté en dernier (écrit paper/), §2.5/§2.6/§3 (relancent
# des exécutions de suites sur dépôts SWE-bench non fournis ou un LLM) ne sont pas tentés.
# Le paquet est copié dans run/ (inscriptible) ; l'original reste intact dans pkg/.
rm -rf run && mkdir run
cp -a pkg/*/. run/
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run:/work:rw -v $PWD/verifie_manifeste.py:/verifie_manifeste.py:ro -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-quarantine timeout 1500"
etape() {
  echo "=================== ETAPE $*"
  s=$(date +%s)
  $P "$@"
  echo "code de sortie : $?  (durée $(( $(date +%s) - s )) s)"
}
etape python3 -I /verifie_manifeste.py /work/results/runs/run_phase4_rerun_20260926_090500
etape python3 -m pytest tests/ -v -p no:cacheprovider
etape python3 scripts/run_sensitivity_analysis.py
etape python3 scripts/analyze_quarantine_remediation.py
etape python3 -c "from scripts._audit_repos_state import audit_all_repos; import json; print(json.dumps(audit_all_repos(), indent=2))"
etape python3 scripts/generate_paper_artifacts.py --run-id run_phase4_rerun_20260926_090500
echo "=================== fichiers modifiés ou créés par rapport au livré"
diff -rq pkg/*/ run/
