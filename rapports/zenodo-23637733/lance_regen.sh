#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/lance_regen.sh sd-92569:work/z23637733/
#   bin/capture.sh rapports/zenodo-23637733/regen.log 'cd ~/work/z23637733 && sh lance_regen.sh'
# Régénération prouvée : sur une copie neuve (run3/), les fichiers de sortie que les commandes du README écrivent
# sont d'abord SUPPRIMÉS (liste ci-dessous), puis les commandes sont rejouées (holdout avec les options du texte du
# README : --coding-sample 150 --seed 20261022). Un fichier présent et identique au livré après coup a donc été réécrit.
# Les entrées (snapshots *.json, codes, prototype_evidence_detail.csv, reconciliation_prototype.csv,
# agent_pr_merge_remedy.json, heldout_codes_ai.csv) ne sont pas supprimées.
rm -rf run3 && mkdir run3 && cp -a pkg/replication_package/. run3/
cd run3 || exit 1
for f in agent_pr_by_org agent_pr_claims agent_pr_claims_summary agent_pr_coding_agreement agent_pr_coding_design agent_pr_coding_sample \
  agent_pr_merge_remedy_summary agent_pr_readiness_by_org agent_pr_summary agent_pr_verdicts public_pr_summary public_pr_verdicts \
  holdout_cluster_bootstrap holdout_comparison instrumentation_asymmetry_copilot_first_window instrumentation_asymmetry_copilot_later_window \
  stress_breakeven baseline_rules; do rm -f results/$f.csv; done
rm -f results/agent_pr_merge_remedy_run_manifest.json results/agent_pr_run_manifest.json results/public_pr_run_manifest.json
rm -f results_holdout/out/agent_pr_by_org.csv results_holdout/out/agent_pr_claims.csv results_holdout/out/agent_pr_claims_summary.csv \
  results_holdout/out/agent_pr_coding_sample.csv results_holdout/out/agent_pr_run_manifest.json results_holdout/out/agent_pr_summary.csv \
  results_holdout/out/agent_pr_verdicts.csv results_holdout/heldout_eval.csv
rm -f results_devin/out/* results_devin/second_agent_comparison.csv
cd ..
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run3:/work:rw -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-evid timeout 1200"
SNAP=simulation/clauses/agent_pr_claims.json
etape() {
  echo "=================== ETAPE $*"
  $P "$@" > /dev/null
  echo "code de sortie : $?"
}
etape python3 simulation/run_public_pr_check.py
etape python3 simulation/run_public_pr_check.py --snapshot results/public_prs_copilot_agent.json --prefix agent_pr --coding-sample 100 --codes results/agent_pr_codes.csv --claims $SNAP --out results
etape python3 simulation/run_merge_remedy.py
etape python3 simulation/run_baselines.py
etape python3 simulation/run_public_pr_check.py --snapshot results_holdout/public_prs_copilot_agent_holdout.json --prefix agent_pr --claims $SNAP --out results_holdout/out --coding-sample 150 --seed 20261022
etape python3 simulation/run_holdout_comparison.py
etape python3 simulation/run_heldout_eval.py
etape python3 simulation/run_cluster_bootstrap.py
etape python3 simulation/run_instrumentation_asymmetry.py
etape python3 simulation/run_stress_breakeven.py
etape python3 simulation/run_public_pr_check.py --snapshot results_devin/public_prs_devin.json --prefix agent_pr --claims $SNAP --out results_devin/out
etape python3 simulation/run_second_agent_comparison.py
echo "=================== SHA256SUMS après régénération"
$P sha256sum -c replication/SHA256SUMS 2>&1 | grep -v ': OK$'
echo "lignes OK : $($P sha256sum -c replication/SHA256SUMS 2>&1 | grep -c ': OK$') sur $(wc -l < pkg/replication_package/replication/SHA256SUMS)"
echo "=================== fichiers absents ou différents de pkg/"
diff -rq pkg/replication_package run3
