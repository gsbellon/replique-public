#!/bin/bash
# bin/compte_rendu.sh bulletin|etat [--essai] : assemble le compte rendu au propriétaire (bin/compte_rendu.py, article 5)
# et le remet à msmtp. Lancé par cron chaque matin (bulletin) et chaque lundi (etat). Avec --essai : affiché, non envoyé.
cd "$HOME/replique" || exit 2
if [ "${2:-}" = "--essai" ]; then python3 -I bin/compte_rendu.py "$1" --essai; exit $?; fi
t="$(mktemp)"; trap 'rm -f "$t"' EXIT
python3 -I bin/compte_rendu.py "$1" > "$t" || { echo "$(date -u +%FT%TZ) compte rendu $1 : assemblage en échec"; exit 1; }
if msmtp -a replique -t < "$t"; then echo "$(date -u +%FT%TZ) compte rendu $1 : envoyé"; else echo "$(date -u +%FT%TZ) compte rendu $1 : envoi en échec"; fi
