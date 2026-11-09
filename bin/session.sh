#!/bin/bash
# Lance une session du mainteneur (auteur ou relecteur) en mode non interactif,
# puis garantit la trace : relevé des tokens, commit, poussée. Article 5 de CLAUDE.md.
set -uo pipefail
ROLE="${1:-auteur}"
case "$ROLE" in auteur|relecteur) ;; *) echo "rôle inconnu : $ROLE" >&2; exit 2;; esac

REPO="$HOME/replique"
cd "$REPO" || exit 2
export PATH="$HOME/.local/bin:$PATH"
export DISABLE_AUTOUPDATER=1
set -a; . "$HOME/secrets/claude.env"; set +a

# Une seule session à la fois
exec 9>"$HOME/.session.lock"
flock -n 9 || { echo "une session tourne déjà" >&2; exit 3; }

TS="$(date -u +%Y-%m-%dT%H%M%SZ)"
OUT="journal/sessions/$TS-$ROLE.json"
ERR="journal/sessions/$TS-$ROLE.err"

# Plafonds par session (versionnés ici, conformément à l'article 5)
MAX_TURNS=80
MAX_BUDGET_USD=8

case "$ROLE" in
  auteur)
    TOOLS="Read,Edit,Write,Glob,Grep,Bash(git *),Bash(ssh sd-92569 *),Bash(bin/*),Bash(bash bin/*),Bash(chmod +x bin/*),Bash(scp *),Bash(ls *),Bash(cat *),Bash(date *),Bash(sha256sum *)" ;;
  relecteur)
    TOOLS="Read,Edit,Write,Glob,Grep,Bash(git *),Bash(bash bin/registre.sh *),Bash(bin/registre.sh *),Bash(bash bin/test_alteration.sh *),Bash(python3 -I bin/compare_csv.py *),Bash(bash bin/test_compare.sh *),Bash(ls *),Bash(cat *),Bash(date *),Bash(sha256sum *)" ;;
esac

reseau_ok() { curl -sS -m 10 -o /dev/null -w '%{http_code}' https://api.anthropic.com/ 2>/dev/null | grep -qE '^[0-9]{3}$' && { ssh -o ConnectTimeout=10 -o BatchMode=yes -T git@github.com 2>&1 || true; } | grep -q 'successfully authenticated'; }
for i in 1 2 3; do reseau_ok && break; echo "réseau indisponible, essai $i/3" >> "$ERR"; [ "$i" = 3 ] && break; sleep 600; done
git pull -q --ff-only 2>/dev/null || true

if reseau_ok; then
timeout 2h claude -p "$(cat "prompts/$ROLE.md")" \
  --output-format json \
  --max-turns "$MAX_TURNS" \
  --max-budget-usd "$MAX_BUDGET_USD" \
  --allowedTools "$TOOLS" \
  --permission-mode dontAsk \
  > "$OUT" 2> "$ERR"
RC=$?
else
  echo "abandon : réseau indisponible, session non lancée" >> "$ERR"; RC=4
fi
{ echo "claude: $(claude --version 2>&1)"; echo "code de sortie: $RC"; } >> "$ERR"

# Relevé des tokens, quoi qu'il soit arrivé
USAGE="journal/USAGE.tsv"
[ -f "$USAGE" ] || printf 'horodatage\trole\tcode\ttours\tcout_estime_usd\tentree\tsortie\tcache_lu\tcache_ecrit\tduree_s\n' > "$USAGE"
if jq -e . "$OUT" >/dev/null 2>&1; then
  jq -r --arg ts "$TS" --arg role "$ROLE" --arg rc "$RC" '
    [$ts, $role, $rc,
     (.num_turns // "?"), (.total_cost_usd // "?"),
     (.usage.input_tokens // "?"), (.usage.output_tokens // "?"),
     (.usage.cache_read_input_tokens // "?"), (.usage.cache_creation_input_tokens // "?"),
     ((.duration_ms // 0) / 1000 | floor)] | @tsv' "$OUT" >> "$USAGE"
else
  printf '%s\t%s\t%s\t?\t?\t?\t?\t?\t?\t?\n' "$TS" "$ROLE" "$RC" >> "$USAGE"
fi

# Registre : si la session a modifié le journal, le lanceur l'inscrit (les sessions ne l'inscrivent jamais elles-mêmes)
if [ -x bin/registre.sh ] && [ -f registre/chaine.tsv ] && [ "$(awk -F'\t' '$4=="journal/JOURNAL.md"{h=$5} END{print h}' registre/chaine.tsv)" != "$(sha256sum journal/JOURNAL.md | cut -d' ' -f1)" ]; then
  bash bin/registre.sh ajoute journal journal/JOURNAL.md >>"$ERR" 2>&1 || echo "registre : inscription du journal en échec" >> "$ERR"
fi
# Trace : commit même si la session n'a rien fait, puis poussée si un remote existe
git add -A
if git diff --cached --quiet; then
  git commit -q --allow-empty -m "session $ROLE $TS : aucune modification (code $RC)"
else
  git commit -q -m "session $ROLE $TS : clôture par le lanceur (code $RC)"
fi
git remote get-url origin >/dev/null 2>&1 && git push -q origin main 2>>"$ERR"
# Second témoin (article 4) : copie courante et copie datée de la tête du registre sur Drive
if [ -f registre/chaine.tsv ] && command -v rclone >/dev/null 2>&1; then
  rclone copy registre/chaine.tsv drive:replique/ 2>>"$ERR" || echo "témoin Drive : copie courante en échec" >> "$ERR"
  rclone copyto registre/chaine.tsv "drive:replique/tetes/chaine-$TS.tsv" 2>>"$ERR" || echo "témoin Drive : copie datée en échec" >> "$ERR"
fi

echo "session $ROLE $TS terminée, code $RC — voir $OUT"
exit "$RC"
