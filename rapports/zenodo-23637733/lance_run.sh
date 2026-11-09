#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/lance_run.sh sd-92569:work/z23637733/
#   bin/capture.sh rapports/zenodo-23637733/run.log 'cd ~/work/z23637733 && sh lance_run.sh'
# Rejoue, dans l'ordre et hors réseau, les commandes de replication/README.md qui ne demandent ni réseau ni gh
# (la dernière, run_contradiction_audit.py, exige le réseau : non exécutée). Le paquet est copié dans run/
# (inscriptible) ; l'original reste intact dans pkg/. Image replab-evid (Python 3.13), sans réseau, sans capacité,
# racine en lecture seule ; chaque étape est bornée à 20 min (timeout) et son code de sortie est noté.
rm -rf run && mkdir run
cp -a pkg/replication_package/. run/
date -u +%Y-%m-%dT%H:%M:%SZ
t0=$(date +%s)
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run:/work:rw -w /work -e HOME=/tmp -e MPLCONFIGDIR=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-evid timeout 1200"
etape() {
  echo "=================== ETAPE $*"
  s=$(date +%s)
  $P "$@"
  echo "code de sortie : $?  (durée $(( $(date +%s) - s )) s)"
}
echo "=================== SHA256SUMS sur l'état livré (avant toute exécution)"
$P sha256sum -c replication/SHA256SUMS 2>&1 | grep -v ': OK$'
echo "lignes OK : $($P sha256sum -c replication/SHA256SUMS 2>&1 | grep -c ': OK$')"
etape python3 simulation/contract_interpreter.py --records results/prototype_evidence_detail.csv --check --strict
etape python3 simulation/run_public_pr_check.py
etape python3 simulation/run_public_pr_check.py --snapshot results/public_prs_copilot_agent.json --prefix agent_pr --coding-sample 100 --codes results/agent_pr_codes.csv --claims simulation/clauses/agent_pr_claims.json --out results
etape python3 simulation/run_merge_remedy.py
etape python3 simulation/make_figures.py
etape python3 simulation/make_specifier_mockup.py
etape python3 -m pytest simulation/ -q
etape python3 simulation/run_baselines.py
etape python3 simulation/run_public_pr_check.py --snapshot results_holdout/public_prs_copilot_agent_holdout.json --prefix agent_pr --claims simulation/clauses/agent_pr_claims.json --out results_holdout/out
etape python3 simulation/run_holdout_comparison.py
etape python3 simulation/run_heldout_eval.py
etape python3 simulation/run_cluster_bootstrap.py
etape python3 simulation/run_instrumentation_asymmetry.py
etape python3 simulation/run_stress_breakeven.py
etape python3 simulation/run_public_pr_check.py --snapshot results_devin/public_prs_devin.json --prefix agent_pr --claims simulation/clauses/agent_pr_claims.json --out results_devin/out
etape python3 simulation/run_second_agent_comparison.py
etape python3 simulation/run_outcome_association.py
echo "=================== SHA256SUMS après exécution"
$P sha256sum -c replication/SHA256SUMS 2>&1 | grep -v ': OK$'
echo "lignes OK : $($P sha256sum -c replication/SHA256SUMS 2>&1 | grep -c ': OK$')"
echo "durée totale (s) : $(( $(date +%s) - t0 ))"
echo "=================== fichiers modifiés dans run/ par rapport à pkg/"
diff -rq pkg/replication_package run
