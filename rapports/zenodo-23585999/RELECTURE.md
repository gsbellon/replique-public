# Relecture de zenodo-23585999 — 2026-10-29 (relecteur)

Décision : le rapport reste à l'état `brouillon`. Une objection, sur un nombre ; le relecteur ne corrige pas les nombres.

## Objection (bloquante)

Résultats, point 1 : « attente de 194 s lancée 9 s après le démarrage (démarrage 20:05:01Z dans `lancement.log`, début de l'attente 20:05:14Z) : l'exécution a duré au plus 3 min 21 s ».

Les deux horodatages cités donnent 13 s d'écart, pas 9 s. Avec 194 s d'attente, la borne est 13 + 194 = 207 s, soit **3 min 27 s**, et non 3 min 21 s (201 s). Le même chiffre figure au journal du 2026-10-29T20:12Z (« moins de 3 min 21 s »). À l'auteur de corriger l'écart et la borne dans le rapport et la phrase d'en-tête du journal si elle est reprise. Le résumé en tête du rapport ne cite pas la durée.

## Vérifié et conforme

- Verdict *reproduit*, portée *paquet*, l'un des trois verdicts de l'art. 6 avec une portée de l'art. 6 ter. Le rapport dit explicitement qu'il ne prétend rien sur l'article.
- Décomptes concordants avec les logs :
  - 222 fichiers livrés, 183 identiques, 39 différents (5 CSV + 9 journaux + 3 PDF + 1 SVG + 21 JSON) : `comparaison_exact.log`.
  - 89 fichiers réécrits, dont 50 identiques (liste de 50 chemins dans `reecrits_identiques.log`) et 39 différents.
  - CSV : 8150 + 435 + 462 + 1414 + 784 = 11 245 cellules ; 22 + 78 + 73 + 317 + 332 = 822 cellules différentes ; écart relatif max 9,58·10⁻¹⁴ ; écart absolu max hors `ownership_tail_paths.csv` 1,16·10⁻¹⁰ : `comparaison_csv.log`.
  - JSON : valeurs 1,0145·10⁻⁸ / 1,1717·10⁻⁸ de `utility_optimizer_max_spending_difference` : `comparaison_1e-9_abs1e-12.log`.
  - Sortie de `run_all.py` (39 programmes, code 0) et de `verify_release.py` : `attente_run.log`, `lancement.log`.
- Chaque nombre est accompagné de la commande (section Commandes) ; les deux commandes abrégées renvoient à la première ligne du log.
- Pas d'intention prêtée ; pas de « fraude » ni de synonyme. La cause de la valeur hors tolérance est déclarée non établie. Conteneur sans réseau, sans capacité, en lecture seule : conforme à l'art. 4.

Une fois le point corrigé, rien d'autre ne s'oppose à `publiable`.

## Seconde relecture — 2026-10-30 (relecteur)

Décision : `brouillon` → `publiable`. Le point 1 du rapport indique désormais 13 s (20:05:01Z dans `lancement.log`, 20:05:14Z dans `attente_run.log`), attente de 194 s (« durée (s) » de `attente_run.log`), borne 207 s = 3 min 27 s : conforme aux logs. Seul le commit 27e298a touche le rapport (ligne du point 1) ; le reste est inchangé depuis la première relecture. Aucune correction de nombre par le relecteur ; seul l'état a changé.
