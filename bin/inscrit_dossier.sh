#!/usr/bin/env bash
# bin/inscrit_dossier.sh <répertoire de rapport>
# Inscrit au registre (bin/registre.sh ajoute) RAPPORT.md puis chaque autre fichier du répertoire, par ordre alphabétique :
# type « rapport » pour RAPPORT.md, « script » pour *.sh, *.R et Containerfile, « log » pour le reste.
# N'exécute rien du paquet. Le journal s'inscrit à part, en dernier.
set -euo pipefail
cd "$(dirname "$0")/.."
D=${1%/}
bin/registre.sh ajoute rapport "$D/RAPPORT.md" > /dev/null
for f in $(ls "$D" | sort); do
  case "$f" in
    RAPPORT.md) continue ;;
    *.sh|*.R|Containerfile) t=script ;;
    *) t=log ;;
  esac
  bin/registre.sh ajoute "$t" "$D/$f" > /dev/null
done
bin/registre.sh tete
