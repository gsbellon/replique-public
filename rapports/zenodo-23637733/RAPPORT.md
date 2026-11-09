# Rapport zenodo-23637733 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Dans un conteneur sans réseau, les commandes de `replication/README.md` qui n'exigent ni réseau ni `gh` s'exécutent toutes avec le code 0, `pytest` passe 40 tests sur 40, et — après suppression préalable de 36 fichiers de sortie (liste dans `lance_regen.sh`) — 34 sont recréés par les commandes du README, identiques octet à octet à ceux du paquet (`regen.log`). Les 2 autres ne sont produits par aucune commande que le README donne ; l'un est régénéré identique par une commande déduite du code (`later.log`), l'autre (`agent_pr_coding_design.csv`) n'a pas été régénéré. Deux réserves sur la documentation du paquet sont dites aux Limites (la commande « holdout » du bloc de code du README produit un fichier qui ne concorde pas avec `SHA256SUMS` ; `make_figures.py` échoue faute de `matplotlib` dans le fichier de versions).

Couverture : *régénération* (les sorties livrées sont régénérées et comparées octet par octet) pour 35 fichiers de résultats (34 + 1, points 3 et 4) ; les figures, l'audit par `gh` et le fichier `agent_pr_coding_design.csv` ne sont pas régénérés.

## Paquet

- Zenodo 23637733, « Replication package for "Evidence Contracts for Auditing Human–AI Software Development: Interpreting Pull-Request Traces under Generative AI" », publié le 2026-10-25, quatre auteurs (Universitat Politècnica de València, Universitat de València), type logiciel, accès ouvert, licence cc-by-4.0 (code MIT selon la description). Fiche : `bin/capture.sh rapports/zenodo-23637733/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23637733'`.
- Un fichier, `replication_package.zip`, 1 184 480 octets ; MD5 de la fiche concordant (`telechargement.log`, ligne « OK ») ; 101 fichiers extraits, code d'extraction 0 (même fichier).
- Données : instantanés pseudonymisés des PR publiques inclus ; les feuilles de codage (noms de comptes) et les dossiers de commentaires ne sont pas distribués, le code du prototype d'allocation non plus (ses sorties figées sont livrées) — `readme.log`. Les entrées nécessaires aux commandes exécutées sont dans le paquet (art. 1 : dans le périmètre).
- Dépendances : `requirements-lock.txt`, « Python 3.14.5 » (`readme.log`).

## Environnement

- sd-92569, podman sans root. Image `replab-evid` (`Containerfile`, `lance_build.sh`) : **Python 3.13.18**, et non 3.14.5, avec les 17 paquets de `requirements-lock.txt` **aux versions exactes** (numpy 2.2.1, scipy 1.17.0, pandas 2.3.3, pyarrow 23.0.1, pytest 9.0.2, etc. : `build_py313.log`). **Écart** : la première tentative sur `python:3.14-slim` a échoué (`build.log`, `code de sortie build : 1`) : numpy 2.2.1 n'a pas de roue pour 3.14, sa compilation exige un compilateur absent de l'image. Je n'ai pas cherché d'autre contournement.
- Archive manipulée sur l'hôte par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) seulement ; aucun code du paquet n'a tourné sur l'hôte.
- Politique de sortie de l'hôte (`politique_sortie.log`) : ports 25, 465, 587 refusés ; destinations journalisées pour l'utilisateur 1001, 20 connexions nouvelles par seconde.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seule une copie du paquet montée en écriture ; l'original reste dans `pkg/`.

## Résultats

1. **Somme de contrôle de l'état livré** (`lance_run.sh`, `run.log`) : `sha256sum -c replication/SHA256SUMS` donne 95 lignes `OK`, aucune autre.
2. **Commandes du README, dans l'ordre** (`lance_run.sh`, `run.log`, 19 s au total) : code 0 pour `contract_interpreter.py --check --strict` (« verdicts agreeing with the observing adapter: 17220/17220 »), `run_public_pr_check.py` (trois formes), `run_merge_remedy.py`, `make_specifier_mockup.py`, `run_baselines.py`, `run_holdout_comparison.py`, `run_heldout_eval.py`, `run_cluster_bootstrap.py`, `run_instrumentation_asymmetry.py`, `run_stress_breakeven.py`, `run_second_agent_comparison.py`, `run_outcome_association.py`. Code 1 : `make_figures.py` (voir Limites). `python3 -m pytest simulation/ -q` : « 40 passed » (la fiche annonce 40 tests).
3. **Régénération prouvée** (`lance_regen.sh`, `regen.log`). Sur une copie neuve, les fichiers de sortie sont supprimés avant de rejouer les commandes (liste dans le script), avec les options du texte du README pour l'échantillon tenu à part (`--coding-sample 150 --seed 20261022`). Les 12 étapes sortent avec le code 0. Le script supprime 36 fichiers (21 dans `results/`, 8 dans `results_holdout/`, 7 dans `results_devin/` : `lance_regen.sh` ; dénombrement des fichiers de `results_devin/out` dans `compte_supprimes.log`). `diff -rq pkg/replication_package run3` ne signale que deux fichiers absents : `results/agent_pr_coding_design.csv` et `results/instrumentation_asymmetry_copilot_later_window.csv`. Donc 34 fichiers supprimés sont recréés, identiques octet à octet à ceux du paquet. `sha256sum -c` donne 93 `OK` sur 95 lignes, les deux manquantes étant ces deux fichiers (les 93 comprennent aussi les fichiers non supprimés : le chiffre ne mesure pas la régénération).
4. **Les deux fichiers restants.** `instrumentation_asymmetry_copilot_later_window.csv` : le README ne cite pas la commande ; `run_instrumentation_asymmetry.py` prend le snapshot et l'étiquette en arguments (`grep_deux.log`, lignes 15-16). En lançant `run_instrumentation_asymmetry.py results_holdout/public_prs_copilot_agent_holdout.json copilot_later_window` (`lance_later.sh`, `later.log`), le fichier supprimé est recréé, « identique au livré ». Cette commande est déduite du code, **pas** du README. `agent_pr_coding_design.csv` n'est écrit que si `--design-reps` est non nul (`grep_deux.log`, lignes 15-18) ; la valeur n'est pas documentée, je n'ai pas essayé : fichier non régénéré.
5. **Commande « holdout » du bloc de code du README, telle qu'écrite** (`graine.log`, cas a1 et a2, deux fois) : sans `--coding-sample 150 --seed 20261022`, `results_holdout/out/agent_pr_summary.csv` diffère du livré (`cmp` : « differ: byte 588, line 2 ») et `SHA256SUMS` signale `FAILED` (`lance_run.sh`, fin de `run.log`, 94 `OK` sur 95). L'écart, par `diff` (`diff_summary.log`), porte sur deux colonnes : `share_EC_SW_01b_capped10` 0,184 livré contre 0,187 régénéré, et `share_EC_SW_01c_capped10` 0,099 contre 0,095 ; les autres colonnes sont égales. Avec les options du texte (cas b), ce fichier est identique au livré ainsi que les six autres fichiers du dossier `out/`. Les deux exécutions sans options donnent le même résultat. Cause : l'échantillon plafonné à 10 par dépôt dépend de la graine (`grep_capped.log`, lignes 5-9 : défaut 20260930).

## Limites

- **Portée paquet.** L'article n'a pas été lu (art. 6 ter) : le rapport dit que les fichiers de résultats du paquet sont régénérés, pas que les nombres de l'article sont retrouvés.
- **Python 3.13 au lieu de 3.14.5** (voir Environnement) ; dépendances aux versions exactes du fichier. Pas essayé sous 3.14.
- **Bloc de code du README incomplet** pour la commande « holdout » (point 5) : un lecteur qui l'exécute tel quel voit une somme de contrôle échouer. Avec les options du texte, tout concorde. Je ne dis pas lequel du bloc ou du texte est « le bon » ; je constate seulement que la combinaison texte + bloc régénère les fichiers livrés.
- **`make_figures.py` échoue** : `ModuleNotFoundError: No module named 'matplotlib'` (`run.log`) ; `matplotlib` n'est pas dans `requirements-lock.txt`. Je ne l'ai pas installé : les figures (`figures/*.svg`) n'ont pas été régénérées ni comparées ; je ne dis rien d'elles.
- **Non exécutés** : `run_contradiction_audit.py` (réseau et `gh`) ; les scripts `fetch_public_prs.py` ; les scripts hors README (`run_sensitivity.py`, `run_paired_intervals.py`, `run_counterexample.py`, `run_insufficient_ablation.py`, `run_lumping_analysis.py`, `run_prototype_evidence.py`, `run_reconciliation_check.py`, `make_contract_parts.py`, `prepare_case_files.py`) — leurs sorties figurent dans `SHA256SUMS` et restent à l'état livré dans `run3/` quand elles n'ont pas été supprimées ; elles ne comptent donc pas parmi les 34 fichiers régénérés.
- **Entrées non régénérables** : les instantanés JSON des PR, les codes humains et IA (`agent_pr_codes.csv`, `heldout_codes_ai.csv`), les sorties figées du prototype ne sont pas reconstruits ; ils sont pris comme livrés. Les codes IA de l'échantillon tenu à part viennent de deux instances d'un même modèle (le paquet le dit lui-même : `replication/README.md`, `readme.log`).
- Une seule exécution complète sur une machine ; les exécutions du point 5 (a1, a2) donnent le même résultat. Pas d'autre répétition.
- Les nombres qui apparaissent dans les points 2 à 5 viennent des fichiers cités ; je n'ai pas relu le code de l'interpréteur pour juger de la correction des clauses.

## Commandes

```
bin/capture.sh rapports/zenodo-23637733/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23637733'
scp rapports/zenodo-23637733/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23637733/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23637733/readme.log 'cat work/z23637733/pkg/replication_package/replication/README.md work/z23637733/pkg/replication_package/replication/requirements-lock.txt'
scp rapports/zenodo-23637733/lance_build.sh rapports/zenodo-23637733/Containerfile sd-92569:work/z23637733/
bin/capture.sh rapports/zenodo-23637733/build.log 'cd ~/work/z23637733 && sh lance_build.sh'          # Python 3.14 : échec (Containerfile alors en 3.14)
bin/capture.sh rapports/zenodo-23637733/build_py313.log 'cd ~/work/z23637733 && sh lance_build.sh'     # Containerfile actuel
scp rapports/zenodo-23637733/lance_run.sh sd-92569:work/z23637733/
bash bin/lance_detache.sh work/z23637733 lance_run.sh run_detache.out
bin/capture.sh rapports/zenodo-23637733/run.log 'cat ~/work/z23637733/run_detache.out'
bin/capture.sh rapports/zenodo-23637733/diff_summary.log 'cd ~/work/z23637733 && diff pkg/replication_package/results_holdout/out/agent_pr_summary.csv run/results_holdout/out/agent_pr_summary.csv; ls -l pkg/replication_package/results_holdout/out run/results_holdout/out'
bin/capture.sh rapports/zenodo-23637733/grep_capped.log 'cd ~/work/z23637733/pkg/replication_package && grep -n -i "capped\|seed\|random\|shuffle\|sample(" simulation/run_public_pr_check.py'
scp rapports/zenodo-23637733/lance_graine.sh sd-92569:work/z23637733/
bin/capture.sh rapports/zenodo-23637733/graine.log 'cd ~/work/z23637733 && sh lance_graine.sh'
scp rapports/zenodo-23637733/lance_regen.sh sd-92569:work/z23637733/
bin/capture.sh rapports/zenodo-23637733/regen.log 'cd ~/work/z23637733 && sh lance_regen.sh'
bin/capture.sh rapports/zenodo-23637733/grep_deux.log 'cd ~/work/z23637733/pkg/replication_package && grep -n "later_window\|first_window\|argv\|add_argument\|coding_design\|design_reps" simulation/run_instrumentation_asymmetry.py simulation/run_public_pr_check.py'
scp rapports/zenodo-23637733/lance_later.sh sd-92569:work/z23637733/
bin/capture.sh rapports/zenodo-23637733/later.log 'cd ~/work/z23637733 && sh lance_later.sh'
bin/capture.sh rapports/zenodo-23637733/politique_sortie.log 'sudo nft list table inet replab; sudo nft list chain ip filter ufw-user-output'
```

Fichiers `suivi1.log`, `suivi2.log`, `reecrits.log` : relevés de contrôle (progression ; les dates de modification ne distinguent pas les fichiers réécrits, car la copie `cp -a` et l'extraction portent toutes la même heure : ils ne servent pas de preuve, d'où `lance_regen.sh`).

Recherche d'origine : `rapports/zenodo-recherche-20261105/recherche.json`, puis `bash bin/liste_zenodo.sh rapports/zenodo-recherche-20261105/recherche.json` et `bash bin/fiche_zenodo.sh rapports/zenodo-recherche-20261105/recherche.json 23647165 23637733`. Choix du paquet : petit (1,2 Mo), Python, instantanés et résultats inclus, suite de tests et sommes de contrôle annoncées, accès ouvert, hors liste de l'art. 6 bis. Non fondé sur l'auteur.

Chaque nombre ci-dessus provient du fichier nommé à côté de lui. Tous les `.log` et `fiche_zenodo.json` ont été produits par `bin/capture.sh` (`compte_supprimes.log` : `bin/capture.sh rapports/zenodo-23637733/compte_supprimes.log 'cd ~/work/z23637733/pkg/replication_package && ls results_devin/out | wc -l; ls results_devin/out; find . -type f | wc -l; find results_holdout/out -type f | wc -l; grep -c "results/\|results_holdout/\|results_devin/" replication/SHA256SUMS'`).
