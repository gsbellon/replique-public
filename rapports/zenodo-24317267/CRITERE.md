# Critère de *reproduit* — zenodo-24317267 (écrit le 2026-11-24, avant toute exécution du paquet)

Portée visée : **paquet** (article 6 ter). L'article est paru dans *Quantitative Economics* selon la fiche, mais la fiche ne donne aucun DOI de revue et l'article n'est pas lu : aucune prétention de portée *article*.

Commande documentée (README.pdf, « Default run ») : installer R et les quatre paquets, régler `project_root` dans `code/00_run_all.R`, lancer ce fichier en laissant `RUN_ESTIMATION <- FALSE`, `RUN_TABLE_A5 <- TRUE`. Le README demande en plus, hors Windows, de changer `type = "windows"` en `type = "cairo"` dans `03_figures_6_9.R`. Ces deux modifications sont les seules faites au code (elles sont documentées) ; elles sont dites au rapport.

Ce que la réexécution par défaut régénère (README, « Shipped results ») : `Table_A1_descriptives.{csv,Rdata}`, `TablesA2_A3_experience.*.Rdata`, `TableA4_paired_tests.*.Rdata`, `unresolved_bound_summary.csv`, `section5_6_validation_counts.csv`, `tuning/Table_A5.Rdata`, les figures `.bmp`, `run_all_log.txt`, `sessionInfo.txt`. Les fichiers `Areas (...) .Rdata` et `tuning_*.Rdata` sont des **entrées** de ce run, livrées : ils ne sont pas régénérés (l'estimation de 37 h et le balayage de 37 h ne sont pas exécutés). La couverture ne sera donc pas complète sur le calcul principal : elle sera dite telle.

Tolérance annoncée par le paquet : aucune pour le run par défaut. Le README (« Notes on reproducibility ») parle de variations de 0,001 sur les mesures de Selten et de la quatrième décimale sur la Table A4 pour un **rerun depuis zéro** sur une autre machine ; ce rerun n'est pas fait, et cette remarque n'est pas utilisée comme tolérance.

Critère appliqué (celui du contrat, 6 ter) :
- CSV : `bin/compare_csv.py --rtol 1e-6 --atol 1e-9`, tout le reste (texte, structure, valeurs manquantes) identique.
- `.Rdata` : chaque objet est aplati en lignes `clé,valeur` (17 chiffres) par `aplatit_rdata.R`, avant et après ; comparaison par `bin/compare_csv.py --rtol 1e-6 --atol 1e-9`. Les `.Rdata` sont aussi comparés octet par octet (`cmp`, information seulement : la sérialisation peut changer sans que les valeurs changent).
- Lignes d'auto-contrôle du paquet dans `run_all_log.txt` (« ALL 168 CELLS MATCH the printed Table A1 », « Section 5.6 reproduced exactly ») : relevées telles quelles, couverture *contrôles internes* pour ces parties.
- Hors verdict, nommés : `run_all_log.txt` et `sessionInfo.txt` (dates, durées, chemins, plateforme, par nature), et les `.bmp` (images : ne se comparent pas ; `sha256sum` donné à titre d'information).
- Rien d'autre n'est écarté. Un seul écart au-delà du critère fait un *divergent*.
