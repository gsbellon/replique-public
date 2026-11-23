# Critère de *reproduit* — écrit le 2026-11-23, avant toute exécution et toute comparaison

Source : CLAUDE.md article 6 ter (v2.6) ; le paquet n'annonce aucune tolérance (`grep` de « toleran », « rtol », « round » dans `readme.log` et `readme_pca.log` : seule mention d'arrondi, « stored decimal precision » des entrées, qui ne vaut pas tolérance de comparaison).

1. Valeurs numériques du JSON `WCHN_partial_correlations_results.json` : `bin/compare_json.py --rtol 1e-6 --atol 1e-9`. Tout le reste du JSON (clés, textes, structure) identique. Aucun champ ignoré.
2. Images (`*.png`, `*.svg`) : ne se comparent pas en valeur ; octet par octet (`cmp`, `sha256sum`) pour information, nommées hors du verdict.
3. Classeurs `.xlsx` : hors de portée (le module `artifact_tool` n'est pas obtenable) ; non régénérés, nommés hors du verdict.
4. Sorties imprimées du script (`PC1+PC2`, `r`, `Holm`) : comparées aux valeurs du JSON livré par `compare_json.py` après extraction, mêmes seuils.
5. Verdict sur le paquet tel que livré : si `python run_wchn.py` échoue, *inexécutable*. Une correction minimale et nommée peut figurer en section « Hors paquet » avec ce qu'elle produit, comparé selon 1 à 4.
