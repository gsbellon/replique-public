# Rapport zenodo-23585246 — état : publiable

Verdict proposé : **divergent** — portée : **paquet**. Le pipeline complet du paquet (`run_all.sh`) s'exécute jusqu'au bout, code 0, et régénère les 31 tables CSV de `output/tables/` fournies. Les fichiers régénérés ne sont pas identiques à ceux du dépôt : sur 104 628 cellules comparées, 47 958 sont égales au caractère près, 12 121 de plus le sont à 10⁻⁶ près (relatif), 44 549 s'en écartent davantage ; 6 381 dépassent 10⁻² et 3 170 dépassent 10⁻¹. Les écarts se concentrent dans les étapes à tirages aléatoires ; les étapes déterministes concordent. **La cause n'est pas établie** (voir Limites). Ce rapport décrit un écart mesuré et n'infère rien d'autre. Aucune comparaison avec les nombres de l'article n'est faite (portée *paquet*, art. 6 ter).

Couverture : *régénération* (les 31 tables CSV livrées sont régénérées et comparées cellule par cellule).

## Paquet

- Zenodo 23585246, « Oil Price Shocks, Sovereign Risk, and Bank Interest Rates Under Full Dollarization » (Équateur), R + Python, 4,8 Mo, données incluses sauf la série VIX (FRED, accès public direct, art. 1). Fiche : `fichiers.json` ; MD5 conforme (`telechargement.log`) ; extraction par `python3 -I` (`extraction.log`, 129 fichiers). README : `readme.log`.
- Le paquet fixe des graines (`set.seed` dans `src/04_var_baseline.R`, `06_…`, `08_…`, `08b_…`, `08c_…`, `09_…` ; `grep_seed.log`). Il ne dit pas, dans les fichiers texte et scripts cherchés (`grep_seed.log`), que les tables sont reproductibles bit à bit.

## Environnement

- sd-92569, podman sans root, image construite `replab-oilecu` (`Containerfile`, `build.log`) : R 4.6.1, seasonal 1.11.0, x13binary 1.1.61.2, urca 1.3.4, strucchange 1.6.0, ggplot2 4.0.3 (versions identiques à celles que le paquet déclare) ; Python 3.14.8, pandas 2.3.3, numpy 2.4.6 (le paquet déclare pandas 3.0.5 et numpy 2.5.2) — écarts sur Python seulement, qui n'intervient pas dans les tables CSV comparées ici, sans que je l'aie vérifié étape par étape.
- Exécution : conteneur `replab-oilecu-run` (id 87ad71e2299a), `--network none --cap-drop all --read-only`, copie inscriptible du paquet montée seule, `SKIP_DOWNLOAD=1`, `bash run_all.sh` (`lance_run.sh`, `lancement_4.log`). Terminé « Exited (0) » (`etat_6.log`). Sortie complète : `run_conteneur.log` (étapes 02 à 13 terminées, code 0).
- Le VIX a été téléchargé sur l'hôte par `curl` seul, hors conteneur (`lance_run.sh`, lignes 14-18), avec renommage de l'en-tête `observation_date` en `date` comme le fait `01_fetch_fred.py`. Plusieurs lancements ont échoué avant (`lancement.log`, `lancement_2.log`, `lancement_3.log`, `etat_*.log`) : détail au journal.

## Commandes

```
bin/capture.sh rapports/zenodo-23585246/lancement_4.log 'cd ~/work/z23585246 && sh lance_run.sh'
bin/capture.sh rapports/zenodo-23585246/etat_6.log 'podman ps -a --format "{{.ID}} {{.Names}} {{.Status}}"'
bin/capture.sh rapports/zenodo-23585246/run_conteneur.log 'podman logs replab-oilecu-run'
scp rapports/zenodo-23585246/compare_tables.sh sd-92569:work/z23585246/
bin/capture.sh rapports/zenodo-23585246/comparaison_tables.log 'cd ~/work/z23585246 && sh compare_tables.sh'
scp rapports/zenodo-23585246/compare_tolerance.py sd-92569:work/z23585246/
bin/capture.sh rapports/zenodo-23585246/comparaison_tolerance.log 'cd ~/work/z23585246 && python3 -I compare_tolerance.py pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/output/tables run/output/tables 1e-6'
bin/capture.sh rapports/zenodo-23585246/comparaison_tolerance_1e-2.log '… compare_tolerance.py … 1e-2'
bin/capture.sh rapports/zenodo-23585246/comparaison_tolerance_1e-1.log '… compare_tolerance.py … 1e-1'
```
(les deux dernières lignes ont la même forme que l'avant-dernière, seule la tolérance change ; la ligne exacte est en tête de chaque log.)

## Résultats

- **Comparaison octet à octet** (`compare_tables.sh`) : les 31 fichiers fournis ont leur homologue régénéré, aucun fichier en plus ; les 31 diffèrent (`comparaison_tables.log`). Cette comparaison est trop sévère : pour `x13_diagnostics.csv`, `diff` signale chaque ligne différente alors que les 21 cellules sont égales (`diff_x13.log` ; `comparaison_tolerance.log`, ligne `x13_diagnostics.csv`) ; la différence d'octets porte donc sur autre chose que le contenu des cellules (je n'ai pas relevé quoi). `compare_tolerance.py` lit les CSV par cellule.
- **Comparaison par cellule** (`comparaison_tolerance.log`, tolérance relative 10⁻⁶) : total 104 628 cellules ; égales 47 958 ; dans la tolérance 12 121 ; hors tolérance 44 549 ; aucune cellule non numérique différente, aucune différence de forme (ligne `TOTAL`). À 10⁻² : 6 381 hors tolérance ; à 10⁻¹ : 3 170 (`comparaison_tolerance_1e-2.log`, `comparaison_tolerance_1e-1.log`). L'écart relatif est pénalisant pour les valeurs proches de zéro.
- **Fichiers concordants** (aucune cellule hors 10⁻⁶) : `descriptives.csv` (écart relatif max 2,1×10⁻¹⁰), `unit_roots.csv` (6,0×10⁻⁹), `kpss_breaks.csv` (6,0×10⁻⁹), `lag_selection_{deposit,lending}_rate.csv` (≤ 1,1×10⁻⁷), `lp_iv_firststage.csv` (8,8×10⁻⁸), `instrument_relevance.csv` (3,0×10⁻¹⁵), `x13_diagnostics.csv` (0). Les statistiques descriptives de la fenêtre d'estimation, VIX compris, concordent donc à 10⁻¹⁰ près.
- **Fichiers divergents** : tous les autres, dont `bvar_hyper_*.csv` (hyperparamètres choisis, 10 cellules sur 33 hors tolérance, écart max 0,35 %), `irf_C0_*.csv` (740 et 741 cellules sur 4 152), `cf_*.csv`, `hist_decomp_*.csv`, `robustness_routes.csv`, `fixed_rate_routes.csv`, `vix_freeze.csv` (120 cellules sur 200, écart max 0,76 %), `lp_iv_irfs.csv` (4 cellules sur 5 010, écart max 4,9×10⁻⁵). Chiffres par fichier : `comparaison_tolerance.log`.
- **VIX** : `check_vix.sh` signale que l'empreinte du VIX téléchargé jusqu'au 22/09/2026 diffère de celle du millésime de l'article (`check_vix.log`) ; le nombre d'observations non manquantes est identique, 9 279 (`diag_vix.log`). Cause non établie.

## Répétabilité (seconde exécution)

Seconde exécution détachée (`lance_run2.sh`, `lancement_run2.log`) : même image, même paquet, même fichier VIX que la première (sha256 identique, `lancement_run2.log`) ; conteneur `replab-oilecu-run2` terminé avec le code 0 (`etat_run2_final.log` ; journal du conteneur dans `etat_run2_podman.log`, 22:20 CET le 28/10, 1 h 16 de CPU).

- **Première contre seconde exécution** (`repet_1e-6.log`, `repet_1e-2.log`) : total 104 628 cellules ; égales 104 628 ; dans la tolérance 0 ; hors tolérance 0 ; aucune différence de texte ni de forme (ligne `TOTAL`). Commande : `python3 -I compare_tolerance.py run/output/tables run2/output/tables 1e-6` (idem à `1e-2`), via `bin/capture.sh`.
- **Seconde exécution contre le paquet** (`run2_vs_paquet_1e-6.log`) : égales 47 958 ; dans la tolérance 12 121 ; hors tolérance 44 549 — mêmes décomptes que pour la première exécution (`comparaison_tolerance.log`). Commande : `python3 -I compare_tolerance.py pkg/oil-shocks-sovereign-risk-ecuador-1.0.0/output/tables run2/output/tables 1e-6`.

Constat : dans cet environnement, avec ce VIX, le pipeline donne deux fois les mêmes 31 tables ; l'écart au paquet est donc stable, non dû au hasard d'une exécution. Cela ne dit rien sur sa cause (VIX, versions, bibliothèques) : seuls ces deux passages dans une même image ont été faits.

## Limites

- **Cause de l'écart non établie.** Les pistes que le dossier ne permet pas de départager : millésime du VIX (l'empreinte diffère), versions logicielles (Python différent ; R et paquets R identiques selon le paquet), bibliothèques numériques de l'image, tirages aléatoires. Aucune exécution n'a isolé l'une d'elles ; ce rapport ne les classe pas. Le fait que les tables déterministes concordent et que celles qui dépendent de tirages divergent est un constat de corrélation entre fichiers, non une explication.
- **Tolérance.** Le seuil 10⁻⁶ est mon choix, non celui du paquet ; les trois seuils sont donnés pour que le lecteur juge. Les écarts relatifs sur des valeurs proches de zéro gonflent le décompte.
- **Pas de lecture de l'article** ni de comparaison des conclusions qualitatives : le rapport ne dit pas si les conclusions du papier tiennent avec les tables régénérées.
- Les figures (`output/figures`) et les tables de `paper/_tables` n'ont pas été comparées ; seules les 31 tables CSV de `output/tables` l'ont été. La répétabilité a été testée par une seconde exécution (section ci-dessus), pas davantage ; aucune exécution n'a eu lieu dans une autre image ni avec un autre VIX.
- **Notification.** Verdict *divergent* : l'auteur correspondant sera notifié après relecture, avec 14 jours de réponse (art. 6) ; rien n'est envoyé à ce stade.
