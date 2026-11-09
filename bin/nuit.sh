#!/bin/bash
# Nuit de Réplique (article 5) : deux cycles auteur–relecteur, lancés par cron à 21 h.
# Le relecteur tourne de préférence sur la station (copie fraîche du témoin GitHub, article 4) ;
# si aucune relecture n'arrive dans l'heure, le pilote relit lui-même. Aucune session après 8 h 30.
cd "$HOME/replique" || exit 2
ATTENTE=3600
fenetre_ouverte() { local h=$((10#$(date +%H%M))); [ "$h" -lt 830 ] || [ "$h" -ge 2100 ]; }
attend_relecture() {
  local depuis="$1" t=0
  while [ "$t" -lt "$ATTENTE" ]; do
    git fetch -q origin main 2>/dev/null
    git log --format=%s "$depuis..origin/main" 2>/dev/null | grep -q '^session relecteur' && return 0
    sleep 120; t=$((t+120))
  done
  return 1
}
for cycle in 1 2; do
  fenetre_ouverte || { echo "$(date -u +%FT%TZ) nuit : fenêtre fermée, cycle $cycle non lancé"; break; }
  bin/session.sh auteur
  ref="$(git rev-parse HEAD)"
  if attend_relecture "$ref"; then
    git pull -q --ff-only origin main
    echo "$(date -u +%FT%TZ) nuit : relecture reçue de la station (cycle $cycle)"
  else
    fenetre_ouverte || break
    echo "$(date -u +%FT%TZ) nuit : pas de relecture de la station dans l'heure, relecture locale (cycle $cycle)"
    bin/session.sh relecteur
  fi
done
# Notifications (6 quater) : conditions vérifiées par le script, une par nuit, copie au propriétaire
bin/notifie.sh >> journal/notifications.log 2>&1
if ! git diff --quiet || [ -n "$(git status --porcelain)" ]; then git add -A; git commit -qm "nuit $(date -u +%F) : passage de bin/notifie.sh"; git push -q origin main; fi
bin/publie.sh >> journal/publication.log 2>&1
echo "$(date -u +%FT%TZ) nuit : terminée"
