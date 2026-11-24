# Rapport zenodo-24317267 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. La commande documentée par le README du paquet (« Default run » : `00_run_all.R` avec `RUN_ESTIMATION <- FALSE`, `RUN_TABLE_A5 <- TRUE`), exécutée dans un conteneur Linux sans réseau avec R 4.3.1 et les quatre paquets R aux versions du README, régénère les 3 CSV livrés et les 4 fichiers `.Rdata` de tables livrés (Tables A1, A2-A3, A4, A5) avec des valeurs égales au critère du 6 ter, en fait égales à l'égalité exacte. Les trois auto-contrôles du paquet donnent les mêmes lignes que dans le journal livré.

Couverture : *régénération*, limitée à ce que le run par défaut recalcule : les tables et figures sont reconstruites à partir des fichiers d'estimation livrés (`Areas (...) .Rdata`, `tuning/tuning_*.Rdata`), qui sont des **entrées** de ce run et ne sont **pas** régénérés (environ 37 h d'estimation et 37 h de balayage selon le README : non tentées). Les 17 figures `.bmp` régénérées sont hors verdict (images).

Critère de *reproduit* : écrit avant l'exécution, `CRITERE.md` (commit de la session ; critère par défaut du contrat, rtol 1e-6, atol 1e-9, aucune tolérance annoncée par le paquet pour ce run).

## Paquet

- Zenodo 24317267, « Replication package for: "Nonparametric Analysis of Reference-Dependent Preferences" », publié le 2026-11-17, type logiciel, accès ouvert, CC BY 4.0, communauté `es-replication-repository` (`fiche_zenodo.json`, commande : `bin/capture.sh rapports/zenodo-24317267/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/24317267'`). Créateurs : Blow, Laura (University of Surrey) ; Crawford, Vincent (University of Oxford). Un fichier, `Replication package.zip`, 3 775 945 octets ; MD5 de la fiche `57f0c892a8049b7c9f53863d22c010bb` concordant (`telechargement.log`, « package.zip: OK » ; script `telecharge.sh`).
- La description de la fiche cite *Quantitative Economics* sans DOI ; aucune relation `related_identifiers` dans la fiche. Trois requêtes de collections de revues (`zenodo-recherche-20261124/req1_ej.json`, `req2_restud.json`, `req3_es.json`) n'ont donné aucune fiche à DOI de revue ; ce paquet est un dépôt récent de Python/R libre. L'article n'est pas lu : portée *article* non revendiquée.
- Contenu (`liste_zip.log`, `python3 -I -m zipfile -l` sur l'exécuteur) : `README.pdf`, `code/00_run_all.R` à `10_figure_A3.R`, `data_raw/` (taxi015.csv, taxi015.dta, CPI…csv), `output/` (résultats livrés). Le README est lu sur le texte de `pdftotext` (`readme.log`) ; `poppler-utils` et `unzip` ont été installés sur l'exécuteur par `sudo apt-get install` (`apt_poppler.log`).

## Environnement

- sd-92569, podman sans root. Image `replab-blowcrawford` (`Containerfile`, `lance_build.sh`, `build2.log`) : base `r-base:4.3.1` désignée par l'empreinte de manifeste `sha256:06979524919e444f50cf01c8e37403a90c7d06daf988c206c3236049f75fe3bd` (`image_base.log`) ; paquets R depuis l'archive CRAN aux versions du README : lpSolve 5.6.19, foreign 0.8-85, lubridate 1.9.3, fmsb 0.7.5, plus generics 0.1.3, timechange 0.2.0, cpp11 0.4.7 (dépendances, versions choisies par moi) ; `build2.log` relève R 4.3.1 et ces versions. Image archivée `~/images/zenodo-24317267.tar`, sha256 `a5b76926f66cf9094817b8da0b6cfdab1cdf79067499b87a11a0c5d164d6b054`, identifiant d'image `84e4b553c8d3daf1df314e2f136c239238a481e962ad5f8ae9c6e7f0d7b02bd1` (`build2.log`). Le premier essai de construction (`build.log`) a échoué faute de `cpp11` (lubridate non installé) et a été refait avec `cpp11` (`build2.log`).
- Archive extraite sur l'hôte par `python3 -I -m zipfile -e` seulement ; aucun code du paquet n'a tourné sur l'hôte.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture (`runA/`), l'original reste dans `pkg/`.
- Différences avec le README, toutes documentées par lui : `project_root` mis à `/work` dans `00_run_all.R` ; `type = "windows"` → `"cairo"` dans `03_figures_6_9.R` (README p. 3). Le diff est dans `run2.log` (lignes « modifications faites au code »). Autres différences non réglables : plateforme Linux (Debian trixie/sid, OpenBLAS) au lieu de Windows 11 (`sessionInfo.txt` comparé dans `compare2.log`).
- Le premier essai de `lance_run.sh` (`run.log`) a échoué (« No code/ folder in project_root ») : le `sed` de `project_root` ne se fondait pas sur les fins de ligne du fichier (CRLF) ; corrigé, relancé (`run2.log`). Le fichier `run1_echec.log` est une trace écrite par erreur en cours de session (un `echo`, sans contenu utile) ; il ne porte aucun résultat.

## Résultats

Exécution (`lance_run.sh`, `run2.log`, code R 0, 4 s ; commande : `bin/capture.sh rapports/zenodo-24317267/run2.log 'cd ~/work/z24317267 && sh lance_run.sh'`) : les neuf scripts 02 à 10 s'exécutent jusqu'à « All scripts finished » ; le journal régénéré contient les lignes d'auto-contrôle suivantes (`compare2.log`, section « lignes d'auto-contrôle »), qui sont des contrôles que le paquet fait lui-même :

1. « ALL 168 CELLS MATCH the printed Table A1. » (dans les deux journaux, livré ligne 32, régénéré ligne 54).
2. « Section 5.6 reproduced exactly. » (deux fois dans chaque journal) ; « REVERSALS in reported comparisons: 0 » (trois modes).
3. « WARP matches the '_final' run on all 21000 draws. » et « LP verdicts differ from the '_final' run on 1 of 21000 draws. » — cette dernière ligne est identique des deux côtés.

Comparaison (`compare.sh`, `bin/compare_csv.py`, `aplatit_rdata.R`, `compare2.log` ; commande : `bin/capture.sh rapports/zenodo-24317267/compare2.log 'cd ~/work/z24317267 && bash compare.sh'`) :

4. CSV `Table_A1_descriptives.csv`, `section5_6_validation_counts.csv`, `unresolved_bound_summary.csv` : `bin/compare_csv.py --rtol 1e-6 --atol 1e-9` « RESULTAT: identique » ; en égalité exacte (atol 0, rtol 0) aussi « identique ». Les octets diffèrent (`cmp`) : le fichier livré porte des fins de ligne CR (22, 7 et 4 CR) et le régénéré aucun (0), `compare2.log`. Écart de format de fin de ligne, hors valeurs.
5. `.Rdata` de tables régénérés (4 fichiers : `Table_A1_descriptives.Rdata`, `TablesA2_A3_experience…final.Rdata`, `TableA4_paired_tests…final.Rdata`, `tuning/Table_A5.Rdata`) : aplatis par `aplatit_rdata.R` (169, 402, 494 et 41 lignes, `compare2.log`) puis comparés par `bin/compare_csv.py --rtol 1e-6 --atol 1e-9` : « identique » pour les quatre. Les octets de ces `.Rdata` diffèrent (`cmp`, « byte 10 ») : information seulement, la sérialisation R n'est pas une comparaison de valeurs.
6. Les neuf fichiers d'entrée livrés (`Areas (Both|Earnings|Hours)…`, `tuning/tuning_*.Rdata`) sont identiques à l'octet entre `pkg/` et `runA/` (`cmp`, `compare2.log`) : ce sont des entrées copiées, non régénérées.

Hors verdict, nommés au critère :
7. 17 figures `.bmp` : toutes différentes à l'octet (`cmp` et `sha256sum`, `compare2.log`, section « images »). Les images ne se comparent pas ; en outre, le paquet livre des figures produites par le périphérique Windows et le run par défaut utilise le périphérique `cairo` (point 4 de la section Environnement) : l'écart d'octets est attendu et ne dit rien des valeurs.
8. `run_all_log.txt` : 748 lignes de diff (dates, chemins `C:\Users\…` contre `/work`, largeur de console), `compare2.log`. `sessionInfo.txt` : plateforme et BLAS différents (Windows 11 ; Debian/OpenBLAS), mêmes versions des quatre paquets.

## Limites

- **Portée paquet.** L'article n'est pas lu ; rien ici ne dit que les nombres de la publication sont retrouvés.
- Les tables sont régénérées à partir de résultats d'estimation **livrés**, non d'une nouvelle estimation (37 h) ni d'un nouveau balayage de Table A5 (37 h). Les passages du README sur la variabilité d'un rerun complet (mesures de Selten à ±0,001, Table A4 à la quatrième décimale ; nombre de résolutions numériques ratées de 421 à 375) ne sont ni confirmés ni infirmés : ce rerun n'a pas été fait.
- Les figures ne sont pas comparées (images). Les valeurs qui les sous-tendent sont dans les `.Rdata` comparés pour les figures A14 et A15 (tables A4) et dans `Areas (...)` (entrée) pour les autres : je ne l'ai pas vérifié script par script.
- Une seule exécution, une seule plateforme (Linux/OpenBLAS) ; je n'ai pas refait l'exécution pour tester sa répétabilité.
- Notification : le verdict n'est pas *divergent*, aucune `NOTIFICATION.md`.

## Commandes

Appels exacts en tête de chaque script, depuis la racine du dépôt : `telecharge.sh` → `telechargement.log` ; `extrait.sh` (échec partiel : `pdftotext` absent, `extrait.log`) puis lectures `readme.log`, `liste_zip.log`, `grep_windows.log`, `code_head.log`, `fiche_zenodo.json`, `image_base.log`, `apt_poppler.log` ; `lance_build.sh` + `Containerfile` → `build.log` (échec) puis `build2.log` ; `lance_run.sh` → `run.log` (échec) puis `run2.log` ; `compare.sh` + `aplatit_rdata.R` + `bin/compare_csv.py` → `compare.log` (aplatissement de `Table_A1_descriptives.Rdata` échoué : matrice non gérée) puis `compare2.log`.
