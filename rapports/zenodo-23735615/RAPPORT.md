# Rapport zenodo-23735615 — état : publiable

Verdict proposé : **inexécutable** — portée : **paquet**. Sur le paquet tel que livré, trois des commandes documentées par `REPLICATION.md` ne donnent pas le résultat annoncé sous Linux dans un conteneur sans réseau : §2.1 (`scripts/generate_paper_artifacts.py`) sort avec le code 1, `ModuleNotFoundError: No module named 'scripts'` ; §2.3 (`pytest tests/`) sort avec le code 1 : 48 réussis, 1 échec (`ModuleNotFoundError: No module named 'requests'`, module non listé par §1), 4 ignorés ; §2.4 (audit des dépôts partagés) sort avec le code 0 mais rapporte `"all_repos_clean": false` et `"Directory does not exist"` pour les cinq dépôts, alors que le document attend `true`. §2.2 (`run_sensitivity_analysis.py`, `analyze_quarantine_remediation.py`) sort avec le code 0. Deux corrections minimales et nommées (section « Hors paquet ») suffisent à obtenir : 49 réussis, 4 ignorés pour les tests, et la régénération de trois tableaux et deux figures ; ces corrections ne sont pas dans le paquet, le verdict porte sur le paquet livré.

Couverture : *contrôles internes* (le paquet vérifie ses propres résultats conservés — manifeste SHA-256 d'un run archivé, suite de tests — sans régénérer ce run). Les tableaux régénérés hors paquet ne sont pas comparés à un fichier livré (le paquet n'en livre pas, `paper/` est absent) mais aux valeurs que `REPLICATION.md` annonce.

## Paquet

- Zenodo 23735615, « Replication Package: Quarantining Environmentally Fragile LLM-Generated Tests », publié le 2026-10-28, un auteur, type logiciel, accès ouvert, licence MIT. Fiche : `bin/capture.sh rapports/zenodo-23735615/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23735615'`.
- Un fichier, `shiguangzhe666/llm-test-generation-quarantine-v1.0.0.zip`, 2 606 328 octets ; MD5 de la fiche concordant (`telechargement.log`, « OK ») ; 1 344 fichiers extraits, code d'extraction 0 (même fichier). Script : `telecharge_extrait.sh`.
- Documentation : `REPLICATION.md` (en chinois), lu par `bin/capture.sh rapports/zenodo-23735615/readme.log '…cat REPLICATION.md…'`. Dépendances annoncées : Python 3.11.x, `pytest pytest-xdist datasets matplotlib numpy scipy`, Git 2.30+ ; LLM local optionnel. Aucune version autre que « Python 3.11 » n'est fixée.
- Le paquet ne contient pas de dossier `paper/` (`inspection.log`, « ls: cannot access 'paper' »), alors que §2.1 décrit des fichiers sous `paper/emse_submission/`.

## Environnement

- sd-92569, podman sans root. Image `replab-quarantine` (`Containerfile`, `lance_build.sh`, `build.log`) : **Python 3.11.18, numpy 2.4.6, scipy 1.17.1, matplotlib 3.11.2, pytest 9.2.0, git 2.47.3** (versions les plus récentes à la date de construction). `pytest-xdist` est installé ; `datasets` ne l'est pas (il ne sert qu'à `explore_swebench.py`, non rejoué).
- Archive manipulée sur l'hôte par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) seulement ; aucun code du paquet n'a tourné sur l'hôte.
- Exécution (`lance_run.sh`) : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture ; l'original reste dans `pkg/`.
- Politique de sortie de l'hôte : celle déjà en place pour les rapports précédents (`rapports/zenodo-23647165/politique_sortie.log`) ; je ne l'ai pas revérifiée pour ce paquet dans cette session.

## Résultats (paquet tel que livré — `run.log`)

1. **Manifeste du run d'autorité** `results/runs/run_phase4_rerun_20260926_090500/manifest.json` (`verifie_manifeste.py`, étape 1 de `run.log`) : 363 entrées déclarées (`files_count` : 363). Les clés utilisent `\` ; lues avec `/`, les 363 fichiers existent. Aucun hachage SHA-256 ne concorde sur les octets livrés (« OK 0 DIFFERENT 363 ») ; **les 363 concordent** si les fins de ligne du fichier livré (LF) sont converties en CRLF avant hachage (« dont concordant en CRLF 363 »). Deux fichiers présents ne sont pas au manifeste : `evidence_audit.json`, `evidence_audit.md`.
2. **§2.3 `python3 -m pytest tests/ -v -p no:cacheprovider`** : code 1, « 1 failed, 48 passed, 4 skipped in 17.70s » ; l'échec est `tests/test_hermetic_ci.py::test_mocked_request_succeeds_in_hermetic_mode` (`import requests`, `ModuleNotFoundError`). `REPLICATION.md` annonce « 48 passed ».
3. **§2.2** `run_sensitivity_analysis.py` : code 0, 308 tests appariés ; au seuil de risque 0,30 et au seuil de défaut 0,50 (défaut) : 182 / 62 / 49 / 15 (59,1 % / 20,1 % / 15,9 % / 4,9 %) ; la même répartition pour le seuil de risque 0,10, 0,20, 0,30, 0,40, et une autre à 0,50 (236 / 8 / 62 / 2). `analyze_quarantine_remediation.py` : code 0, 5 instances avec tests en quarantaine, 103 occurrences `UNMOCKED_NETWORK_URL`.
4. **§2.4** audit des dépôts : code 0 du processus mais `"all_repos_clean": false` ; les cinq dépôts « Directory does not exist » ; le script écrit un fichier sous le chemin littéral `F:\论文\llm-test-stability\data\repos_state_audit.json`. `REPLICATION.md` attend `all_repos_clean: true`.
5. **§2.1** `generate_paper_artifacts.py --run-id run_phase4_rerun_20260926_090500` : code 1, `ModuleNotFoundError: No module named 'scripts'` (ligne `from scripts.run_phase4_study import INSTANCE_CONFIGS`). La cause en amont est `PROJECT_ROOT = Path(r"F:\论文\llm-test-stability")` en dur (`inspection2.log`, lignes 4-5, 25).

## Hors paquet (`lance_hors_paquet.sh`, `hors_paquet.log`)

Deux corrections, sans modifier une ligne du paquet :

- **`requests`** : image dérivée `replab-quarantine-req` = `replab-quarantine` + `pip install requests` (requests 2.34.2 ; réseau à la construction seulement). Alors `pytest tests/ -v` : code 0, « 49 passed, 4 skipped in 17.75s » (48 annoncés ; le test supplémentaire est celui qui échouait ci-dessus ; je n'ai pas cherché d'où vient l'écart de comptage).
- **Chemin en dur** : un lien symbolique de nom `F:\论文\llm-test-stability` vers `.` dans la copie (`ln -s . 'run2/F:\论文\llm-test-stability'`). Alors `generate_paper_artifacts.py --run-id run_phase4_rerun_20260926_090500` : code 0, « Loaded 13 valid instances, 4 excluded instances », trois tableaux (`tab_benchmark_matrix.tex`, `tab_strategy_comparison.tex`, `tab_hypothesis_tests.tex`) et deux figures (`fig_pareto_frontier`, `fig_triage_breakdown`, PDF et PNG) créés sous `paper/` et `paper/emse_submission/` (`artefacts.log`). Les valeurs lues dans `artefacts.log` : Risk-Aware-Triage rétention exécutable 77,5 ± 18,2, quarantaine 19,5 ± 15,8, déterminisme CI 100,0, rétention de défauts 100,0 ; test de Wilcoxon sur le taux de quarantaine : W = 0,0, p = 0,0591, Â12 = 0,69 ; ce sont les valeurs que `REPLICATION.md` §4 annonce pour les tables 2 et 3.
- `REPLICATION.md` §2.1 énumère sept tableaux et quatre figures ; la commande n'en a produit que trois et deux (`artefacts.log`). Je n'ai pas cherché quel autre script produit les autres.

## Limites

- **Portée paquet.** L'article n'a pas été lu : rien ici ne dit que les nombres de l'article sont retrouvés.
- **Non exécutés** : §2.5 (`run_hermetic_ci_benchmark.py`), §2.6 (`run_multi_model_benchmark.py`), §3 (`run_phase4_rerun.py`, 25 à 45 minutes selon le paquet, avec exécution de suites sur les dépôts SWE-bench) : l'audit du point 4 montre que les dépôts partagés qu'ils supposent ne sont pas présents dans le paquet extrait ; je ne les ai pas tentés. Je ne dis rien du tableau 5 ni du tableau 6.
- **Hachages** : la concordance avec fins de ligne CRLF montre que le manifeste a été calculé sur les fichiers tels qu'ils étaient sur la machine Windows de l'auteur ; je ne sais pas si l'archive Zenodo a normalisé les fins de ligne (la présence d'un `.gitattributes` est constatée dans `telechargement.log`, son contenu n'a pas été lu). Ce n'est pas une preuve que les fichiers livrés sont identiques à ceux de l'auteur ; c'est la concordance de hachage après une transformation, rien de plus.
- **Versions non fixées** : numpy 2.4.6, scipy 1.17.1, etc. sont celles d'aujourd'hui.
- Une seule exécution de chaque commande ; pas de répétition. `run.log` est celui de la seconde exécution de `lance_run.sh` (la première, dont le vérificateur ne lisait pas les clés à `\`, a été écrasée ; seul le vérificateur a changé).

## Commandes

Appels exacts en tête de chaque script, depuis la racine du dépôt :

- `telecharge_extrait.sh` → `telechargement.log`, `lance_build.sh` + `Containerfile` → `build.log`, `lance_run.sh` + `verifie_manifeste.py` → `run.log`, `lance_hors_paquet.sh` → `hors_paquet.log`.
- Lectures : `readme.log` (`cat REPLICATION.md…`), `manifest_apercu.log`, `inspection.log`, `inspection2.log` (grep), `artefacts.log` (`find paper` et `cat` des deux tableaux), `fiche_zenodo.json`.
