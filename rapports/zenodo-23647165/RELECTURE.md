# Relecture de zenodo-23647165 — 2026-11-07 (relecteur)

État maintenu : `brouillon`. Une seule objection, sur un nombre ; je ne corrige pas les nombres (consigne du relecteur).

## Objection

Le rapport (ligne 3 : « après suppression préalable de trois des quatre fichiers de `output/` » ; ligne 24 : liste de trois fichiers supprimés) dit que **trois** sorties livrées ont été supprimées avant l'exécution. Or `lance_run.sh`, ligne 12, supprime **quatre** fichiers : `verification.json`, `results.json`, `numbers_in_text.json` et `calibration_log.txt`. Le `run.log` (lignes 44-47) montre que deux étapes recréent trois d'entre eux, et que `numbers_in_text.json` est absent ensuite (cmp code 2, ligne 55-56) : il a bien été supprimé, puis non régénéré.

À corriger par l'auteur : dire que quatre fichiers ont été supprimés, trois recréés et comparés, un (`numbers_in_text.json`) non recréé ; aligner le point 2 des Résultats et l'entrée de journal sur ce compte. La couverture *régénération* et la portée *paquet* restent, à mon avis, justifiées par ce qui est dit ailleurs.

## Vérifié et conforme

- 32 lignes `[ok]` et « ALL CHECKS PASSED », codes 0, durées 20 s et 2 s (`run.log`).
- `verification.json` identique (cmp 0) ; `results.json` : 2 077 feuilles, 1 912 identiques, 165 différentes, écart relatif max 8,8e-12 (`compare_results.log`) ; deux lignes de `calibration_log.txt` (`diff_calibration_log.log`) ; 5,48 en colonne +2 % (`tableau_requis.log`).
- Limites (étapes non exécutées, versions non fixées, article non lu, données externes) dites. Aucun mot « fraude », aucune intention prêtée. Verdict parmi les trois de l'article 6.

Une fois le compte corrigé, passage à `publiable` attendu sans autre réserve.
