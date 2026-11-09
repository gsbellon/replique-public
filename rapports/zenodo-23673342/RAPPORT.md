# Rapport zenodo-23673342 — état : publiable

Verdict : **reproduit** — portée : **paquet**. La commande documentée `Rscript run_all.R` s'exécute jusqu'au bout, code 0, en 638 s, sur les microdonnées publiques de l'IBGE (recensements 2010 et 2022) téléchargées à part, dans un conteneur sans réseau ; les 17 contrôles du paquet passent (`All checks passed.`, `run_full.log`). Les 35 fichiers de `output/` que l'exécution réécrit sont tous régénérés : 8 identiques à l'octet, 27 qui diffèrent seulement par des écarts de calcul flottant — écart relatif maximal 4,2·10⁻¹² sur les cellules non quasi nulles, aucune différence de texte dans les CSV de résultats (`comparaison_full.log`). Trois fichiers, `figure/Figura_1.png`, `session_info.txt` et `outputs_sha256.csv`, diffèrent à l'octet par nature (image, session, empreintes des fichiers précédents). Quatorze fichiers de `output/` ne sont pas réécrits par cette commande (voir Limites). Ce rapport ne compare pas aux nombres de l'article, non lu (art. 6 ter).

Couverture : *régénération* (les sorties livrées sont régénérées et comparées ; 35 fichiers sur 49, les 14 autres n'étant pas produits par `run_all.R`).

## Paquet

- Zenodo 23673342, indice de Benefit-of-the-Doubt à référence fixe sur les déficits Alkire-Foster, Brésil 1991–2022 (Brandão, Mariano, Rebelatto), R, licence MIT, 0,5 Mo. Fiche et recherche d'origine : `rapports/zenodo-recherche-20261105/recherche.json`. Archive téléchargée, MD5 conforme (`telechargement.log`), extraite par `python3 -I` (74 fichiers). README : `readme.log`.
- Données : non incluses, mais en accès public direct sur le FTP de l'IBGE (art. 1 : admis). Recensement 2010 : 27 archives par UF plus `Documentacao.zip` ; recensement 2022 : `Todas_as_UFs.zip`, 1 087 747 933 octets. Téléchargement par `curl` seul, sur l'hôte, sans code du paquet : toutes les lignes `code=0`, ligne `FIN` (`telechargement_ibge.log`, script `telecharge_ibge.sh`). Les empreintes SHA-256 des entrées sont dans `inputs_sha256.csv` du paquet, identique à celui livré (`comparaison_full.log`).
- Étape 09 (série 1991–2000, fichiers SPSS non redistribués) : non exécutable sans ces fichiers, et ils ne sont pas en accès public direct ; elle se saute d'elle-même (`stage 09 skipped`, `run_full.log`). Hors de ce rapport.

## Environnement

- sd-92569, podman sans root. Image `replab-bodmpi` (`Containerfile`, `lance_build.sh`, `build.log`) : `r-base:latest` avec R 4.6.1 (2026-06-24), rDEA 1.2-8, Benchmarking 0.33 (installés depuis CRAN, réseau à la construction seulement), `data.table` et `lpSolve` en paquets Debian. Le README annonce R 4.5.3 sur macOS ; `haven` n'est pas installé (étape 09 facultative).
- Exécution (`lance_run.sh`, lancée détachée par `bin/lance_detache.sh`) : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie inscriptible du paquet (`run_full/`) montée seule, `raw/` en lecture seule ; l'original reste intact dans `pkg/`. Aucun secret à bord.
- Politique de sortie de l'hôte (relevée à 2026-11-05T20:01:47Z, avant l'exécution du 20:10 ; `politique_sortie.log`) : port 25 refusé, destinations journalisées à 20 nouvelles connexions par seconde pour l'utilisateur 1001.

## Résultats

1. **Exécution complète.** `Rscript run_all.R` : code 0, 638 s (début 2026-11-05T20:10:22Z, fin 20:21:00Z) ; étapes 01 à 08, 10, 11 terminées ; 6 113 887 ménages en 2010 (20 526 018 personnes), 7 603 456 ménages en 2022 ; ligne de pauvreté 262,78 R$ ; indice du Brésil, τ = 0,5 : 0,4858 (2010), 0,239 (2022) (`run_full.log`). 17 lignes `PASS` (`grep -c PASS rapports/zenodo-23673342/run_full.log` → 17).
2. **Quels fichiers ont été réécrits.** `TZ=UTC find run_full/output -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort` (`mtimes_full.log`) : 35 fichiers portent une date d'écriture entre 20:10:28Z et 20:21:00Z ; 14 gardent la date de la copie initiale (20:01:16Z) et ne sont donc pas régénérés par cette exécution.
3. **Comparaison avec `output/` livré** : `python3 -I compare_output.py pkg/output run_full/output` (`lance_compare.sh run_full`, `comparaison_full.log`). Sur 49 fichiers fournis : 22 identiques à l'octet, 27 différents, 0 absent, aucun fichier supplémentaire. Parmi les 22 identiques, 8 sont régénérés (`base_2010_counts.csv`, `base_2022_counts.csv`, `inputs_sha256.csv`, `numerical_example/example.csv`, `parameters.csv`, `af/missing_income.csv`, `robustness/bootstrap_change_brazil.csv`, `robustness/rank_range_tau.csv`) et 14 ne sont pas réécrits (point 2).
4. **Les 27 fichiers différents.** 24 CSV de résultats, en-têtes et nombres de lignes identiques, aucune cellule de texte différente ; tous les écarts sont numériques. Écart relatif maximal par fichier : de 2,9·10⁻¹⁵ (`bootstrap_change_uf.csv`) à 4,2·10⁻¹² (`dominant_indicator.csv`), 1,0·10⁻¹² à 1,4·10⁻¹² pour `scores_uf.csv`, `change_uf.csv`, `solver_check.csv`, `alternative_versions_uf.csv`. Les scores du Brésil et des UF ne dépassent pas 1,03·10⁻¹² relatif.
5. **Trois fichiers d'audit à grand écart relatif.** `audit/interference.csv` (écart relatif max 1,0), `audit/monotonicity_person.csv` et `audit/monotonicity_profile.csv` (2,0) : cellules dont la valeur est du bruit autour de zéro. `python3 -I compare_abs.py pkg/output run_full/output audit/interference.csv audit/monotonicity_person.csv audit/monotonicity_profile.csv` (`comparaison_abs.log`) : les cellules à écart relatif > 10⁻³ (18, 111 et 67) ont un écart absolu maximal de 4,4·10⁻¹⁶ et une valeur absolue maximale de 1,2·10⁻¹⁵ ; sur l'ensemble de chaque fichier l'écart absolu maximal est 3,8·10⁻¹³, 1,9·10⁻¹³ et 2,3·10⁻¹³.
6. **Fichiers qui diffèrent par nature.** `figure/Figura_1.png` (différent à l'octet, non comparé en contenu) ; `session_info.txt` (versions de la session) ; `outputs_sha256.csv` (26 cellules de texte différentes, ce sont les empreintes des fichiers de résultats qui diffèrent à l'octet).
7. **Chemins sans microdonnées** (séance antérieure, même image) : `check_results.R` 17 PASS, `review_v4.R` PASS, `run_all.R 05 08 10 11` sur les profils agrégés livrés : 41 fichiers sur 49 identiques à l'octet, écart relatif max 9,3·10⁻¹⁴ sur 5 CSV de scores (`run_agg.log`, `comparaison_agg.log`, `lance_agg.sh`).

## Limites

- **Choix du verdict.** Le paquet ne donne pas de critère de tolérance pour les sorties. *Reproduit* repose sur ma lecture : des écarts de l'ordre de 10⁻¹² relatif (10⁻¹³ absolu sur les fichiers d'audit) sont du flottant, non une différence de résultat. Un lecteur qui exigerait l'égalité à l'octet lirait *divergent* ; l'écart est mesuré et publié, le relecteur peut trancher autrement.
- **14 fichiers non régénérés** : `series/*` (5 fichiers, produits par l'étape 09 sautée), `audit/AF3_conference.csv`, `AF3_headcounts_conference.csv`, `population_standardization.csv`, `saved_scores_recomputed.csv`, `scope_subgroup_counterexample.csv`, `territorial_subgroup_decomposition.csv` (écrits par `tests/review_v4.R`, que `run_all.R` n'appelle pas ; `grep` dans `grep_non_regeneres.log`), `audit/input_series_sha256.csv`, `audit/testes_v4.log`, `af/profiles_income_mw.csv` (aucune écriture trouvée par `grep` dans les scripts R ni le README). Leur identité avec le livré ne prouve rien ici. `review_v4.R` a passé dans la séance antérieure sur les profils livrés (`run_agg.log`), pas sur les profils régénérés.
- La série historique 1991–2000 n'a pas été reproduite (fichiers SPSS non fournis ni en accès direct) ; le README le dit lui-même.
- Les microdonnées de l'IBGE ont pu être corrigées depuis la publication du paquet (le README le signale) ; leurs empreintes (`inputs_sha256.csv`) sont identiques à celles livrées, ce qui est cohérent avec des entrées inchangées.
- Une seule exécution complète ; la répétabilité n'a pas été testée. Environnement différent de celui de l'auteur (Linux, R 4.6.1, contre macOS, R 4.5.3 annoncé).
- Les figures n'ont pas été comparées en contenu ; rien n'est dit de la validité de la méthode ni de l'article.

## Commandes

```
scp rapports/zenodo-23673342/telecharge_extrait.sh sd-92569:work/z23673342/
bin/capture.sh rapports/zenodo-23673342/telechargement.log 'cd ~/work/z23673342 && sh telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23673342/readme.log 'cat work/z23673342/pkg/README.md'
scp rapports/zenodo-23673342/Containerfile rapports/zenodo-23673342/lance_build.sh sd-92569:work/z23673342/
bin/capture.sh rapports/zenodo-23673342/build.log 'cd ~/work/z23673342 && sh lance_build.sh'
bin/capture.sh rapports/zenodo-23673342/politique_sortie.log 'sudo nft list table inet replab; sudo nft list chain ip filter ufw-user-output'
scp rapports/zenodo-23673342/telecharge_ibge.sh sd-92569:work/z23673342/ ; bin/lance_detache.sh work/z23673342 telecharge_ibge.sh telechargement_ibge.log
scp rapports/zenodo-23673342/lance_run.sh sd-92569:work/z23673342/ ; bin/lance_detache.sh work/z23673342 lance_run.sh run_full.log
bin/capture.sh rapports/zenodo-23673342/run_full.log 'cat ~/work/z23673342/run_full.log'
bin/capture.sh rapports/zenodo-23673342/telechargement_ibge.log 'cat ~/work/z23673342/telechargement_ibge.log'
scp rapports/zenodo-23673342/compare_output.py rapports/zenodo-23673342/lance_compare.sh sd-92569:work/z23673342/
bin/capture.sh rapports/zenodo-23673342/comparaison_full.log 'cd ~/work/z23673342 && sh lance_compare.sh run_full'
bin/capture.sh rapports/zenodo-23673342/mtimes_full.log "cd ~/work/z23673342 && TZ=UTC find run_full/output -type f -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort"
scp rapports/zenodo-23673342/compare_abs.py sd-92569:work/z23673342/
bin/capture.sh rapports/zenodo-23673342/comparaison_abs.log 'cd ~/work/z23673342 && python3 -I compare_abs.py pkg/output run_full/output audit/interference.csv audit/monotonicity_person.csv audit/monotonicity_profile.csv'
bin/capture.sh rapports/zenodo-23673342/grep_non_regeneres.log "cd ~/work/z23673342/pkg && grep -rnE '<noms des 14 fichiers>' --include=*.R --include=*.md ."
scp rapports/zenodo-23673342/lance_agg.sh sd-92569:work/z23673342/ ; bin/capture.sh rapports/zenodo-23673342/run_agg.log 'cd ~/work/z23673342 && sh lance_agg.sh'
```

Choix du paquet : sa taille et sa nature (R, données publiques directes), non fondé sur l'auteur (art. 6 bis : aucun des auteurs n'est dans la liste). Chaque nombre ci-dessus provient du fichier nommé à côté de lui ; les `.log` ont été produits par `bin/capture.sh` ou copiés par `scp`. Le détail de la commande de `grep_non_regeneres.log` est celle consignée dans l'en-tête du fichier. Les durées et empreintes d'entrée citées viennent de `run_full.log` et `comparaison_full.log`.
