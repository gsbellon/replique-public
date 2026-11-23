#!/bin/bash
# Nuit de Réplique (article 5) : deux cycles auteur–relecteur, lancés par cron à 21 h.
# Le relecteur tourne de préférence sur la station (copie fraîche du témoin GitHub, article 4) ;
# si aucune relecture n'arrive dans l'heure, le pilote relit lui-même. Aucune session après 8 h 30.
cd "$HOME/replique" || exit 2
# Le journal modifié par un script (relève, notification) s'inscrit au registre ici, par comparaison à la chaîne, comme dans bin/session.sh.
inscrit_journal() { [ "$(awk -F'\t' '$4=="journal/JOURNAL.md"{h=$5} END{print h}' registre/chaine.tsv)" = "$(sha256sum journal/JOURNAL.md | cut -d' ' -f1)" ] || bash bin/registre.sh ajoute journal journal/JOURNAL.md >/dev/null 2>&1; }
pousse() { if [ -n "$(git status --porcelain)" ]; then git add -A; git commit -qm "nuit $(date -u +%F) : $1"; git push -q origin main; fi; }
# Courrier (article 4), puis veto (article 3) : la relève passe d'abord, pour qu'un STOP reçu dans la journée arrête cette nuit.
git pull -q --ff-only origin main 2>/dev/null
bash bin/releve.sh >> journal/releve.log 2>&1
if [ -f journal/STOP ]; then
  inscrit_journal; pousse "sessions suspendues (journal/STOP)"
  echo "$(date -u +%FT%TZ) nuit : sessions suspendues (journal/STOP), rien lancé"; exit 0
fi
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
inscrit_journal; pousse "passage de bin/notifie.sh"
bin/publie.sh >> journal/publication.log 2>&1
echo "$(date -u +%FT%TZ) nuit : terminée"
