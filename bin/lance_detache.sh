#!/bin/bash
# bin/lance_detache.sh <répertoire distant sous ~> <script sh dans ce répertoire> <journal de sortie distant>
# Démarre sur sd-92569, détaché (nohup, setsid), `sh <script>` depuis <répertoire> ; sortie standard et erreur dans
# <journal>. Imprime l'identifiant de processus, le répertoire et la date, puis rend la main. N'exécute rien de tiers
# lui-même : le script distant est un script du dépôt (qui lance le code tiers en conteneur).
# Relevé du résultat par le cycle suivant : `ssh sd-92569 'cat <répertoire>/<journal>'` via bin/capture.sh.
set -eu
D="$1"; S="$2"; L="$3"
ssh sd-92569 "cd ~/$D && (nohup setsid sh $S > $L 2>&1 < /dev/null &) ; sleep 2; echo \"lancé : \$(date -u +%Y-%m-%dT%H:%M:%SZ) répertoire ~/$D script $S journal $L\"; pgrep -u \$(id -u) -f \"sh $S\" | head -3"
