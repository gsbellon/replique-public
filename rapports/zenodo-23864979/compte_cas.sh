#!/bin/bash
# Compte les cas de surplus du consommateur neutre listés par l'étude B dans run.log.
# Appel : bash rapports/zenodo-23864979/compte_cas.sh   (depuis la racine du dépôt)
# Écrit la commande, la sortie et le code dans rapports/zenodo-23864979/compte_cas.log
D=rapports/zenodo-23864979
{
  echo "# commande : grep -c \"^('G\" $D/run.log"
  grep -c "^('G" "$D/run.log"
  echo "# code de sortie : $?"
} > "$D/compte_cas.log"
cat "$D/compte_cas.log"
