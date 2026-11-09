# Rapport zenodo-23624408 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet** (la commande d'entrée du paquet, `Rscript run_all.R`, s'exécute jusqu'au bout sur les microdonnées IBGE ; ses dix contrôles passent ; les 51 fichiers CSV de résultats fournis sont régénérés avec la même forme, les mêmes cellules textuelles et des valeurs numériques égales à l'arrondi flottant près — voir Résultats pour les écarts exacts, dont l'absence d'identité octet à octet). Les nombres de l'article (manuscrit v11) ne sont pas comparés (art. 6 ter).

Couverture : *régénération* (les 51 CSV de résultats fournis sont régénérés et comparés).

## Paquet

- Zenodo 23624408, « DEA-MP/H: replication package for household multidimensional poverty measurement », version 1.1.0, publié le 2026-10-24, licence MIT, un fichier `DEA-MP-H_v1.1.0_artigo_v11.zip` (121 764 octets). Fiche : `fiche_zenodo.json` (`bin/capture.sh rapports/zenodo-23624408/fiche_zenodo.json "curl -s -m 30 'https://zenodo.org/api/records/23624408'"`). Découverte : `rapports/zenodo-recherche-20261026/f23624408.json` (liste des fichiers, MD5 annoncé `f9755f3b…be1`).
- MD5 obtenu après téléchargement : identique (`telechargement.log`, ligne 4 ; `extraction.log`, ligne 5). 72 fichiers extraits (`extraction.log`, ligne 6).
- Données : le paquet **n'inclut pas** les microdonnées ; son README (`readme.log`, lignes 7-10, 60, 173) dit que `R/01_download.R` les télécharge depuis `ftp.ibge.gov.br` (≈ 1,2 Go pour 2010 et 1,0 Go pour 2022, `readme.log` lignes 175-176). Accès public direct, sans inscription ni formulaire (art. 1) : les requêtes HEAD sont dans `ibge_index.log`.
- Commande documentée (`readme.log`, lignes 64-67) : `Rscript run_all.R` (étapes 01 à 09 puis `tests/check_results.R`). Le paquet affirme que le test d'étape finale compare aussi les estimations aux valeurs de l'article si `tests/expected_values.csv` existe (`readme.log`, lignes 132-133) ; ce fichier n'est pas dans l'archive (`brazil_csv.log`, ligne 10 : `ls pkg/tests` ne liste que `check_results.R`), donc cette comparaison n'a pas eu lieu.

## Environnement

- sd-92569, podman sans root. Image `replab-deamph` (`Containerfile`) : base `docker.io/library/r-base:latest` + `unzip gawk libglpk-dev r-cran-data.table r-cran-lpsolve` (apt) + `rDEA` depuis CRAN. Réseau ouvert **à la construction seulement** (dépôts Debian, `cloud.r-project.org`). Versions : R 4.6.1, data.table 1.18.6.1, rDEA 1.2.8, lpSolve 5.6.23 (`build.log`, avant-dernier bloc). Le paquet n'indique que « R 4.2 ou plus » (`readme.log`, ligne 53) ; la session d'origine était R 4.5.3 sous macOS arm64 (`diffs.log`, lignes 189-213).
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp` ; paquet, microdonnées en lecture seule ; seuls `out/` et `work/` (neufs) en écriture (`lance_run.sh`). Aucun code du paquet n'a tourné sur l'hôte (archive extraite par `python3 -I`, `extrait.sh`).
- **Écart de procédure à connaître.** Le conteneur n'ayant pas de réseau, les 29 + 1 fichiers IBGE ont été téléchargés avant par `curl` sur l'hôte, aux URL de `R/01_download.R` (`telecharge_ibge.sh`, `telechargement_ibge.log` : 503 s, tous codes 0) ; l'étape 01 du paquet n'a donc rien téléchargé et n'a fait que calculer les SHA-256 (`run_all.log`, lignes 5-14). C'est la voie « fichiers placés à la main » du README (`readme.log`, ligne 60). Taille du fichier 2022 : 1 087 747 933 octets, égale à l'annonce du serveur (`ibge_index.log`, ligne 21 ; `telechargement_ibge.log`).
- Aucun paquet ni donnée n'a été fourni par un tiers autre que Zenodo, IBGE, Debian et CRAN.

## Commandes

```
bin/capture.sh rapports/zenodo-23624408/fiche_zenodo.json "curl -s -m 30 'https://zenodo.org/api/records/23624408'"
bin/capture.sh rapports/zenodo-23624408/telechargement.log "mkdir -p ~/work/z23624408 && curl -s -m 120 -o ~/work/z23624408/pkg.zip 'https://zenodo.org/api/records/23624408/files/DEA-MP-H_v1.1.0_artigo_v11.zip/content' ; md5sum ~/work/z23624408/pkg.zip"
scp rapports/zenodo-23624408/extrait.sh sd-92569:work/z23624408/
bin/capture.sh rapports/zenodo-23624408/extraction.log 'cd ~/work/z23624408 && sh extrait.sh'
bin/capture.sh rapports/zenodo-23624408/readme.log 'cd ~/work/z23624408/pkg && cat README.md R/01_download.R run_all.R'
scp rapports/zenodo-23624408/telecharge_ibge.sh sd-92569:work/z23624408/
bin/capture.sh rapports/zenodo-23624408/telechargement_ibge.log 'cd ~/work/z23624408 && sh telecharge_ibge.sh'
scp rapports/zenodo-23624408/lance_build.sh rapports/zenodo-23624408/Containerfile sd-92569:work/z23624408/
bin/capture.sh rapports/zenodo-23624408/build.log 'cd ~/work/z23624408 && sh lance_build.sh'
scp rapports/zenodo-23624408/lance_run.sh sd-92569:work/z23624408/
bin/capture.sh rapports/zenodo-23624408/run_all.log 'cd ~/work/z23624408 && sh lance_run.sh'
scp rapports/zenodo-23624408/compare.sh rapports/zenodo-23624408/diffs.sh rapports/zenodo-23624408/lance_ecarts.sh rapports/zenodo-23624408/ecarts.R sd-92569:work/z23624408/
bin/capture.sh rapports/zenodo-23624408/comparaison.log 'cd ~/work/z23624408 && sh compare.sh'
bin/capture.sh rapports/zenodo-23624408/diffs.log 'cd ~/work/z23624408 && sh diffs.sh'
bin/capture.sh rapports/zenodo-23624408/ecarts.log 'cd ~/work/z23624408 && sh lance_ecarts.sh'
```

Autres relevés (lecture seule) : `ressources.log` (disque, mémoire, images), `politique_sortie.log` (règles de sortie), `config.log` (`R/config.R`), `check_results.log` (`tests/check_results.R`, `R/09_manifest.R`), `sha_lignes.log` (`outputs_sha256.csv`), `brazil_csv.log`.

## Résultats

- **Exécution.** `Rscript run_all.R` : code de sortie **0**, durée totale 3 928 s (`run_all.log`, lignes 348-351). Les neuf étapes se terminent (`run_all.log`, lignes 14, 46, 77, 99, 116, 138, 182, 332, 336) ; l'étape 08 (robustesse) dure 47,7 min (ligne 332). Aucune occurrence de « warning » ni « error » dans le log.
- **Contrôles du paquet.** Dix lignes `PASS` et `All checks passed.` (`run_all.log`, lignes 337-347), dont l'accord GLPK/lpSolve à moins de 1e-8, les monotonicités, la non-interférence et l'exemple numérique M = 0,834375.
- **Entrées.** `inputs_sha256.csv` régénéré est **identique octet à octet** à celui du paquet (`diffs.log`, lignes 186-187) : mêmes fichiers IBGE que ceux de l'article.
- **Fichiers de résultats.** 53 fichiers fournis dans `output/` (`extraction.log`) ; 52 régénérés, `run_log.txt` absent de `out/` parce que le journal d'exécution va sur la sortie standard (`run_all.log`) — hypothèse non vérifiée dans le code ; `session_info.txt` y est présent et décrit un autre environnement. Comparaison octet à octet (`comparaison.log`, avant-dernière ligne de résultats) : **26 identiques, 26 différents, 1 absent**. Les 26 différents ne sont donc **pas** identiques au fichier fourni.
- **Taille des écarts** (`ecarts.log`, 51 CSV comparés cellule par cellule) : mêmes dimensions et mêmes noms de colonnes pour 50 des 51, cellules non numériques identiques pour ces 50 (le 51ᵉ, `outputs_sha256.csv`, a 52 lignes contre 53 et un ordre de lignes différent — `sha_lignes.log` ; ses valeurs sont des empreintes de fichiers, qui diffèrent puisque 26 fichiers diffèrent). Plus grand écart absolu sur toute cellule numérique : 5,9e-10 (`national/descriptives_brazil.csv`, sur une valeur d'environ 1 578, soit un écart relatif de 3,6e-13 ; `diffs.log` lignes 129-135) ; plus grand écart relatif : 1, attribué à des cellules proches de zéro (`national/dominance.csv`, écart absolu maximal 7,55e-14 ; ex. −1,04e-14 fourni contre 0 régénéré, `diffs.log` lignes 60 et 88) et 1,06e-10 pour `robustness/bootstrap_differences_municipalities.csv` (écart absolu 3,7e-15). Hors ces cellules proches de zéro, tous les écarts relatifs sont inférieurs ou égaux à 8,2e-13 (`ecarts.log`).
- **Valeurs principales** (échantillon, `diffs.log` lignes 4-10 ; colonnes `ano,n,M,T,H,above1`, `brazil_csv.log` ligne 4) : Brésil 2010, n = 6 111 832, M fourni 0,0921440696851099 / régénéré 0,0921440696851273 ; T 1,20922448263976 / 1,20922448263998 ; H 12,5766653027953 / 12,5766653027959. Brésil 2022, n = 7 602 162, M 0,0770375254123048 / 0,0770375254123079. Les effectifs, les tables municipales (huit municipalités, classements 1 à 8 inchangés, `diffs.log` lignes 11-29) et le fichier `dominance.csv` (colonnes booléennes identiques, `diffs.log` lignes 53-109) sont identiques sur toutes les cellules non flottantes.

## Limites

- **« Reproduit » ne veut pas dire « identique à l'octet ».** Les écarts d'arrondi sont attribuables, sans que ce rapport l'ait démontré, à l'environnement numérique (R 4.6.1 / OpenBLAS / GLPK sous Linux x86-64 contre R 4.5.3 / BLAS d'Apple sous arm64, `diffs.log` lignes 189-244) ; aucune expérience n'a isolé la cause. Conséquence constatée : le manifeste `output/outputs_sha256.csv` fourni par le paquet n'est pas retrouvé par cette exécution (26 fichiers diffèrent, donc leurs empreintes aussi) ; le paquet dit seulement que le résultat ne dépend pas du nombre de cœurs (`readme.log`, lignes 110-112), pas qu'il est identique d'une plateforme à l'autre.
- Portée *paquet* : les fichiers de résultats fournis sont régénérés par son code. Les nombres cités dans le manuscrit v11 (non lu) ne sont pas comparés ; `tests/expected_values.csv` n'existe pas dans l'archive. Aucune évaluation de la méthode.
- Le téléchargement des microdonnées n'a pas été exécuté par le code du paquet (voir Environnement). La version d'IBGE utilisée est celle des fichiers présents sur le serveur au 26/10/2026 ; l'identité des SHA-256 d'entrée avec ceux du paquet établit que c'est la même version que celle de l'auteur.
- Image dérivée avec versions plus récentes que celles de l'auteur (R 4.6.1 contre 4.5.3 ; paquets R voisins, `diffs.log` lignes 209-213 et 240-244). Les paquets rDEA et lpSolve ont les mêmes versions.
- Aucun auteur n'est notifié : le verdict n'est pas *divergent* (art. 6).
