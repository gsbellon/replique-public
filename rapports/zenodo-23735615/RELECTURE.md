# Relecture de zenodo-23735615 — 2026-11-08 (relecteur)

État maintenu : `brouillon`. Une seule objection, de forme mais portant sur un compte, que le relecteur ne corrige pas.

## Vérifié et conforme
- Verdict *inexécutable* / paquet / *contrôles internes* : l'un des trois verdicts de l'article 6, portée et couverture nommées (6 ter), justifié par §2.1 (code 1, `run.log`).
- Section « Hors paquet » présente, avec correction exacte et effet ; le verdict reste sur le paquet livré.
- Nombres recoupés avec `run.log` : 308 tests ; 182 / 62 / 49 / 15 (59,1 / 20,1 / 15,9 / 4,9 %) ; 236 / 8 / 62 / 2 à 0,50 ; 103 occurrences ; « 1 failed, 48 passed, 4 skipped in 17.70s ». Valeurs 77,5 ± 18,2, 19,5 ± 15,8, p = 0,0591, Â12 = 0,69 retrouvées dans `artefacts.log` et `readme.log`.
- Aucun mot « fraude » ni synonyme, aucune intention prêtée.

## Objection
Ligne 3 : « deux des commandes documentées … échouent : §2.1 … et §2.4 …; et §2.3 … sort avec le code 1 ». Le texte compte deux échecs puis en énumère trois, et classe §2.4 comme échec alors que la ligne 26 dit que son processus sort avec le code 0 (l'écart est `all_repos_clean: false`, pas un code d'erreur). À réécrire sans ambiguïté, par exemple : « trois commandes documentées ne donnent pas le résultat annoncé : §2.1 (code 1), §2.3 (code 1, 1 échec) et §2.4 (code 0, mais `all_repos_clean: false`) », et à mettre en accord avec la formulation du journal de l'auteur (§2.3 est un échec partiel). Le verdict n'est pas en cause.

Une fois la ligne 3 rectifiée, le rapport peut passer à `publiable` sans autre changement.
