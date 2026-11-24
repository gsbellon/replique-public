# Relecture — zenodo-23585246 (2026-10-28, relecteur)

**Décision : `brouillon` → `publiable`** (divergent / paquet).

Contrôlé contre les logs : totaux 104 628 / 47 958 / 12 121 / 44 549 (`comparaison_tolerance.log`, ligne TOTAL) ; 6 381 hors 10⁻² et 3 170 hors 10⁻¹ (lignes TOTAL des deux autres logs) ; écarts relatifs max et décomptes par fichier cités (descriptives, unit_roots, kpss_breaks, lag_selection, lp_iv_firststage, instrument_relevance, x13, bvar_hyper, irf_C0, vix_freeze, lp_iv_irfs) ; 31 fichiers fournis / 31 régénérés, aucun en plus (`comparaison_tables.log`) ; étapes 02 à 13 dans `run_conteneur.log` ; « Exited (0) » dans `etat_6.log` ; graines dans `grep_seed.log` ; 9 279 observations VIX dans `diag_vix.log` ; options de conteneur dans `lance_run.sh` (`--network none`, `--cap-drop all`, `--read-only`). Tous concordent. Aucun mot interdit ni intention prêtée ; la cause est déclarée non établie et aucune piste n'est classée.

**Verdict.** *Divergent* décrit un écart mesuré sur les fichiers de résultats fournis ; la portée *paquet* est tenue (pas de comparaison à l'article, dit en tête et en Limites). Le seuil 10⁻⁶ est signalé comme choix de l'auteur, avec deux autres seuils.

## Seconde relecture (2026-10-29, relecteur) — section « Répétabilité »

**Décision : `brouillon` → `publiable`** (divergent / paquet), après ajout de la section Répétabilité.

Contrôlé : 104 628 cellules, 104 628 égales, 0 hors tolérance, aux seuils 10⁻⁶ et 10⁻² (`repet_1e-6.log`, `repet_1e-2.log`, lignes TOTAL, commandes en tête) ; seconde exécution contre paquet 47 958 / 12 121 / 44 549, identique à la première (`run2_vs_paquet_1e-6.log`) ; sha256 VIX identique pour `run/` et `run2/` (`lancement_run2.log`) ; code 0 et horodatages 21:05:36 → 22:20:46 (`etat_run2_final.log`) ; 1 h 15 min 53 s de CPU (`etat_run2_podman.log`, arrondi à 1 h 16 dans le rapport). Concordance complète ; la conclusion est limitée à ce que les deux passages établissent et la cause reste déclarée non établie. La réserve (2) ci-dessous est levée ; (1) et (3) subsistent, notamment la notification de l'art. 6 avant toute publication.

**Réserves non bloquantes (première relecture).** (1) `compare_tolerance.py` est inscrit sous le type `log` : à corriger par entrée nouvelle si l'auteur le juge utile. (2) Un seul passage d'exécution : la répétabilité du pipeline n'est pas testée, ce que le rapport dit ; une seconde exécution renforcerait le verdict avant notification. (3) La notification à l'auteur correspondant (art. 6, 14 jours) reste à faire avant publication ; rien n'est publié ici.
