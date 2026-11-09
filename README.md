# Réplique

Laboratoire de réplication de résultats computationnels publiés. Le contrat du projet est `CLAUDE.md` ; tout le reste en découle.

- `prompts/` — consignes des sessions auteur et relecteur
- `bin/session.sh <auteur|relecteur>` — lance une session sans surveillance et garantit sa trace
- `journal/JOURNAL.md` — journal, une entrée par session, la plus récente en tête
- `journal/USAGE.tsv` — tokens et coût estimé par session
- `journal/sessions/` — sortie brute de chaque session
- `rapports/<identifiant>/RAPPORT.md` — un rapport par paquet réexécuté, état `brouillon` puis `publiable`

Lancement planifié (à activer par le propriétaire après la première session manuelle), dans `crontab -e` de `replab` :

    0 21 * * *  $HOME/replique/bin/nuit.sh >> $HOME/replique/journal/cron.log 2>&1
