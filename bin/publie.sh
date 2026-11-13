#!/bin/bash
# bin/publie.sh — sas de publication (6 quater). Copie dans le dépôt public ce qui peut l'être, et rien d'autre.
# Publié : contrat, README, prompts, bin, registre, USAGE.tsv, SIGNATURE, journal avec quatorze jours de retard,
# rapports `publiable` ou `retiré` dont l'embargo est levé (non divergent ; ou divergent avec ENVOI.md de plus de 14 jours, ou REPONSE.md).
# Jamais publié : NOTIFICATION.md et ENVOI.md (adresses de tiers), journal/sessions, rapports en brouillon ou sous embargo.
# Le journal publié s'arrête avant la plus ancienne entrée qui nomme un dossier sous embargo : rien d'un rapport
# divergent ne sort avant la fin du délai de l'article 6, pas même par le journal (correctif du 2026-11-13).
set -uo pipefail
cd "$HOME/replique" || exit 2
PUB="$HOME/publication"; DEPOT_PUBLIC="git@github-public:gsbellon/replique-public.git"
# Sous embargo : rapport divergent, sans réponse jointe, et non notifié ou notifié depuis quatorze jours au plus.
sous_embargo() {
  local d="$1" fin
  grep -qi 'verdict[^:]*: \*\*divergent\*\*' "$d/RAPPORT.md" 2>/dev/null || return 1
  [ -f "$d/REPONSE.md" ] && return 1
  [ -f "$d/ENVOI.md" ] || return 0
  fin="$(grep -m1 "jusqu" "$d/ENVOI.md" | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' | tail -1)"
  [ -n "$fin" ] && [ "$(date -u +%F)" \> "$fin" ] && return 1
  return 0
}
if [ ! -d "$PUB/.git" ]; then git clone -q "$DEPOT_PUBLIC" "$PUB" 2>/dev/null || { mkdir -p "$PUB" && git -C "$PUB" init -q -b main && git -C "$PUB" remote add origin "$DEPOT_PUBLIC"; }; fi
git -C "$PUB" pull -q --ff-only origin main 2>/dev/null || true
rm -rf "$PUB/rapports" "$PUB/journal" "$PUB/registre" "$PUB/bin" "$PUB/prompts"
mkdir -p "$PUB/rapports" "$PUB/journal"
cp CLAUDE.md README.md "$PUB/"; [ -f CLAUDE.en.md ] && cp CLAUDE.en.md "$PUB/"
cp -r bin prompts registre "$PUB/"; cp journal/USAGE.tsv "$PUB/journal/" 2>/dev/null; cp rapports/SIGNATURE.md "$PUB/rapports/" 2>/dev/null
EMBARGO=""
for d in rapports/zenodo-*/; do d="${d%/}"; sous_embargo "$d" && EMBARGO="$EMBARGO ${d##*zenodo-}"; done
echo "$(date -u +%FT%TZ) dossiers sous embargo :${EMBARGO:- aucun}"
python3 - "$PUB/journal/JOURNAL.md" $EMBARGO <<'PY'
import re,sys,datetime
out=sys.argv[1]; ids=sys.argv[2:]; s=open('journal/JOURNAL.md').read(); head,sep,rest=s.partition('\n---\n')
limite=(datetime.datetime.now(datetime.timezone.utc)-datetime.timedelta(days=14)).strftime('%Y-%m-%d')
blocs=rest.split('\n---\n')
# Entrées de la plus récente à la plus ancienne : on ne garde que celles qui suivent, dans le fichier, la plus ancienne entrée nommant un dossier sous embargo.
coupe=max([i for i,b in enumerate(blocs) if any(x in b for x in ids)],default=-1)
garde=[b for i,b in enumerate(blocs) if i>coupe and (m:=re.search(r'^## (\d{4}-\d{2}-\d{2})',b.strip(),re.M)) and m.group(1)<=limite]
note='\n\n> Journal publié avec quatorze jours de retard (article 6 quater)'+(', et arrêté avant la première entrée qui nomme un rapport sous embargo (article 6)' if coupe>=0 else '')+' ; le journal complet est dans le dépôt de travail, privé.\n'
open(out,'w').write(head+note+sep+'\n---\n'.join(garde))
PY
for d in rapports/zenodo-*/; do
  d="${d%/}"; r="$d/RAPPORT.md"; [ -f "$r" ] || continue
  grep -q 'état : publiable\|état : retiré' "$r" || continue
  sous_embargo "$d" && continue
  mkdir -p "$PUB/$d" && cp -r "$d/." "$PUB/$d/" && rm -f "$PUB/$d/NOTIFICATION.md" "$PUB/$d/ENVOI.md"
done
cd "$PUB" && git add -A
if ! git diff --cached --quiet; then git -c user.name=replab -c user.email=replab@replique-pilote commit -qm "publication $(date -u +%FT%TZ)" && git push -q -u origin main && echo "$(date -u +%FT%TZ) publication poussée"; else echo "$(date -u +%FT%TZ) rien à publier"; fi
