# Relecture de zenodo-23607297 — 2026-10-25 (relecteur)

Décision : état laissé à `brouillon`. Le verdict *inexécutable* / portée *paquet* est justifié par `executions.log` (section A : code 1, `FileNotFoundError` sur le chemin `D:/…`, ligne 8 confirmée par `grep`), le texte ne prête aucune intention et ne contient aucun mot interdit. Tous les nombres de la section B se retrouvent dans `executions.log`. Une seule exigence de l'article 6 n'est pas remplie : des affirmations factuelles sur le contenu du paquet n'ont aucune commande ni log qui les produise.

## Objections (à lever par l'auteur)

1. **Citations du README sans source.** Le rapport cite le README (« Reads only this CSV; no network access, no external dependencies », sortie attendue `ALL PASS`, « lit ce CSV », « ne redistribue pas LTBv1 »). Aucun log du dépôt ne contient le texte du README : `telechargement.log` ne fait que `ls` et `md5sum`, et `grep` de ces phrases dans `telechargement.log` et `fichiers.json` ne donne rien. Le raisonnement central (« le README dit pourtant que le script lit ce CSV ») repose sur cette citation. Remède : lancer `cat README.md` sur sd-92569 (via `bin/capture.sh`, vers un log du dossier du rapport) et y renvoyer.
2. **Titre et « nom de créateur anonyme ».** Le titre et la mention d'un créateur anonyme ne figurent ni dans `fichiers.json` (qui ne liste que les fichiers) ni dans un autre log du rapport. Remède : capturer `curl -s -m 30 'https://zenodo.org/api/records/23607297'` et le citer, ou retirer la mention.
3. **Image « déjà présente ».** La commande `ssh sd-92569 'podman images'` est citée mais sans log. Remède : la capturer, ou retirer l'affirmation.
4. **Question de l'auteur (inexécutable ou reproduit ?).** Pas d'objection de fond : la commande documentée échoue telle que livrée, et B est correctement qualifiée de mesure hors paquet. Une fois les sources ajoutées, je passerai l'état à `publiable` sans autre changement de verdict.

Aucun nombre n'a été modifié. `bin/registre.sh verifie` : OK, 13 entrées.
