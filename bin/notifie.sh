#!/bin/bash
# bin/notifie.sh — envoi des notifications de l'article 6 (6 quater). Code de confiance : ne juge rien, vérifie et envoie.
# Conditions, toutes requises : rapport `publiable` ; verdict *divergent* ; NOTIFICATION.md avec en-têtes
# "To: <adresse>", "Source: <commande qui a établi l'adresse>", "Subject: <objet>", une ligne vide, puis le corps exact ;
# aucun ENVOI.md. Une notification par appel. Copie au propriétaire (~/secrets/copie.txt). Trace : ENVOI.md, registre, journal.
set -uo pipefail
cd "$HOME/replique" || exit 2
command -v msmtp >/dev/null 2>&1 || { echo "msmtp absent : aucun envoi"; exit 0; }
[ -f "$HOME/.msmtprc" ] || { echo "msmtprc absent : aucun envoi"; exit 0; }
COPIE="$(cat "$HOME/secrets/copie.txt" 2>/dev/null || true)"
for d in rapports/zenodo-*/; do
  d="${d%/}"; r="$d/RAPPORT.md"; n="$d/NOTIFICATION.md"
  [ -f "$r" ] && [ -f "$n" ] || continue
  [ -f "$d/ENVOI.md" ] && continue
  grep -q 'état : publiable' "$r" || continue
  grep -qi 'verdict[^:]*: \*\*divergent\*\*' "$r" || continue
  to="$(grep -m1 '^To: ' "$n" | sed 's/^To: //; s/[[:space:]]*$//')"
  src="$(grep -m1 '^Source: ' "$n" | sed 's/^Source: //')"
  subject="$(grep -m1 '^Subject: ' "$n" | sed 's/^Subject: //')"
  if ! [[ "$to" =~ ^[^@[:space:]]+@[^@[:space:]]+\.[A-Za-z]+$ ]] || [ -z "$src" ] || [ -z "$subject" ]; then
    echo "$d : en-têtes To/Source/Subject incomplets, envoi non fait"; continue
  fi
  body="$(awk 'BEGIN{h=1} h&&/^[[:space:]]*$/{h=0;next} !h{print}' "$n")"
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  {
    echo "From: Réplique <contact@replique-lab.org>"
    echo "To: $to"
    [ -n "$COPIE" ] && echo "Bcc: $COPIE"
    echo "Subject: $subject"
    echo "MIME-Version: 1.0"; echo "Content-Type: text/plain; charset=UTF-8"; echo
    printf '%s\n' "$body"
    printf '\n\n----- Full report (RAPPORT.md, as reviewed) -----\n\n'; cat "$r"
  } | msmtp -a replique -t
  rc=$?
  if [ "$rc" -ne 0 ]; then echo "$ts envoi en échec ($rc) : $d"; continue; fi
  fin="$(date -u -d "$ts +14 days" +%Y-%m-%d)"
  printf '# Envoi de la notification (6 quater)\n\n- Date (UTC) : %s\n- Destinataire : %s\n- Source de l'"'"'adresse : %s\n- Copie au propriétaire : %s\n- Délai de réponse : 14 jours, jusqu'"'"'au %s\n- Envoyé par bin/notifie.sh, conditions vérifiées : publiable, divergent, aucun envoi antérieur\n' "$ts" "$to" "$src" "${COPIE:+oui}" "$fin" > "$d/ENVOI.md"
  bash bin/registre.sh ajoute notification "$d/ENVOI.md" >/dev/null 2>&1 || true
  python3 - "$d" "$ts" "$to" "$fin" <<'PY'
import sys; d,ts,to,fin=sys.argv[1:]
p='journal/JOURNAL.md'; s=open(p).read(); head,sep,rest=s.partition('\n---\n')
e=f"\n---\n\n## {ts} — notification envoyée (bin/notifie.sh)\n\n`{d}` : notification de l'article 6 envoyée à l'auteur correspondant depuis contact@replique-lab.org (adresse dans ENVOI.md, non publié), copie au propriétaire. Délai de réponse jusqu'au {fin}. Détail : `{d}/ENVOI.md`. Publication du rapport après ce délai ou la réponse.\n"
open(p,'w').write(head+e+sep+rest)
PY
  echo "$ts notification envoyée : $d → $to"
  exit 0
done
exit 0
