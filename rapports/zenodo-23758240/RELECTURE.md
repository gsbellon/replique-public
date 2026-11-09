# Relecture de zenodo-23758240 — 2026-10-31 (relecteur)

Décision : le rapport reste `brouillon`. Une seule objection, sur le verdict ; le reste est conforme.

## Contrôlé et conforme

- Décomptes recoupés avec `comparaison_csv.log` : 36 + 36 + 3 135 + 121 600 + 4 940 = 129 747 cellules ; 11 + 9 + 801 + 566 + 957 = 2 344 cellules différentes à l'octet ; 0 cellule non numérique différente ; seuils 10⁻¹² (3 cellules) et 10⁻⁹ (2 cellules) ; maxima par fichier.
- Les deux valeurs de l'écart (0,25 / 0,3 ; 0,15063… / 0,15364…) sont celles de `ligne77.log` et de `comparaison_csv.log`.
- Durée 20:02:10Z → 20:03:22Z = 72 s, « 7600 runs in 66s », codes 0 : conformes à `run.log`. Deux fichiers identiques à l'octet : conformes à `comparaison_octets.log`.
- Chaque nombre a sa commande ou son journal ; le texte ne prête aucune intention et n'emploie ni « fraude » ni synonyme ; l'hésitation de l'auteur est exposée sans détour.

## Objection (verdict non justifié par ce qui précède)

1. La portée *paquet* est définie à l'art. 6 ter par « les fichiers de résultats fournis sont régénérés par son code ». Le rapport établit lui-même qu'une ligne de `paired_vs_reactive.csv` ne l'est pas : `wins_minus_losses` 0,25 → 0,3 (écart relatif 1,67·10⁻¹) et `p_value` 0,1506 → 0,1536 sont des écarts mesurés, sans rapport avec l'arrondi flottant. Le point 4 déclare n'en avoir établi ni la cause ni la répétabilité (une seule exécution, bibliothèques plus récentes, `analyse.py` non lu). Le motif donné pour *reproduit* (« le reste est retrouvé ») ne répond pas à cet écart ; il ne justifie ni *reproduit* ni, tel quel, l'abandon de *divergent*, qui « décrit un écart mesuré » (art. 6).

   Pour passer, au choix de l'auteur :
   - (a) verdict **divergent / paquet**, qui décrit l'écart sans en inférer la cause, avec notification à l'auteur correspondant (art. 6) — la seule voie compatible avec ce que le rapport établit aujourd'hui ; ou
   - (b) maintenir *reproduit* seulement après avoir établi, par des commandes consignées, que l'écart tient à l'environnement ou au calcul (relecture de la partie de `analyse.py` qui produit cette ligne ; seconde exécution ; si possible versions de bibliothèques proches des bornes basses du `requirements.txt`), et le dire dans le rapport. Si la cause n'est pas établie, (b) ne tient pas.

   Je ne tranche pas à la place de l'auteur ; je ne passe pas à `publiable` un verdict que le texte lui-même juge hésitant sur le point qui le décide.

## Remarque de forme (non bloquante)

- Résultats, point 3 : « au dernier chiffre flottant près » est exact pour `raw_results.csv` (max 1,31·10⁻¹⁵) ; la liste des colonnes touchées n'est pas relevée, ce que le texte dit déjà.
