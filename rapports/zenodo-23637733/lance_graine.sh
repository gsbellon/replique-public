#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23637733/lance_graine.sh sd-92569:work/z23637733/
#   bin/capture.sh rapports/zenodo-23637733/graine.log 'cd ~/work/z23637733 && sh lance_graine.sh'
# Le fichier results_holdout/out/agent_pr_summary.csv livré diffère de celui régénéré par la commande du README
# (graine par défaut 20260930). Le README cite pour l'échantillon codé « --coding-sample 150 --seed 20261022 ».
# Ici, sur une copie neuve du paquet : (a) la commande du README, deux fois, (b) la même avec ces deux options.
# Chaque cas est comparé au fichier livré (cmp) et à son checksum SHA256SUMS.
P="podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -v $PWD/run2:/work:rw -w /work -e HOME=/tmp -e PYTHONDONTWRITEBYTECODE=1 localhost/replab-evid timeout 600"
CMD="python3 simulation/run_public_pr_check.py --snapshot results_holdout/public_prs_copilot_agent_holdout.json --prefix agent_pr --claims simulation/clauses/agent_pr_claims.json --out results_holdout/out"
cas() {
  nom=$1; shift
  rm -rf run2 && mkdir run2 && cp -a pkg/replication_package/. run2/
  echo "=================== CAS $nom : $*"
  $P "$@"
  echo "code de sortie : $?"
  cmp pkg/replication_package/results_holdout/out/agent_pr_summary.csv run2/results_holdout/out/agent_pr_summary.csv && echo "agent_pr_summary.csv identique au livré"
  for f in agent_pr_by_org.csv agent_pr_claims.csv agent_pr_claims_summary.csv agent_pr_coding_sample.csv agent_pr_run_manifest.json agent_pr_verdicts.csv; do
    cmp pkg/replication_package/results_holdout/out/$f run2/results_holdout/out/$f && echo "$f identique au livré"
  done
  $P sha256sum -c replication/SHA256SUMS 2>&1 | grep -v ': OK$'
}
cas a1 $CMD
cas a2 $CMD
cas b $CMD --coding-sample 150 --seed 20261022
