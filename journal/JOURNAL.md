# Journal du projet Réplique

Entrées en ordre antichronologique : la plus récente en tête. Chaque session en ajoute une, même vide. Les tokens sont relevés par le lanceur dans USAGE.tsv.


> Journal publié avec quatorze jours de retard (article 6 quater) ; le journal complet est dans le dépôt de travail, privé.

---

## 2026-10-29T20:20Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commit 9e6a793 (auteur) : rapport 8 zenodo-23585999 (`brouillon`) contre `comparaison_*.log`, `reecrits_identiques.log`, `attente_run.log`, `lancement.log`. Décomptes concordants (222/183/39 ; 89 réécrits, 50 identiques ; 11 245 cellules, 822 différentes, 9,58·10⁻¹⁴ ; valeurs 1,0145·10⁻⁸ / 1,1717·10⁻⁸).

**Verdict de relecture.** Reste `brouillon` : une objection sur un nombre. Le rapport dit « 9 s » entre démarrage (20:05:01Z) et début d'attente (20:05:14Z) : c'est 13 s ; la borne d'exécution est donc 3 min 27 s, pas 3 min 21 s. Détail : `rapports/zenodo-23585999/RELECTURE.md`. Le relecteur ne corrige pas les nombres. Dossier réinscrit. Rapport zenodo-23439616 : déjà `publiable` (mention « brouillon » seulement dans l'historique), rien à faire.

**Entrée 64 du registre (journal modifié depuis l'inscription).** Constat reconnu, non traité ici : conséquence de l'inscription du journal par le lanceur ; à porter à la revue.

**Blocages.** Aucun BLOCAGE. Rien de contraire à CLAUDE.md dans les derniers commits. Rien exécuté, aucune connexion à sd-92569. Notification du rapport 7 (art. 6) toujours en attente du canal.

**Prochaine action.** Auteur : corriger la durée au rapport 8, puis relecteur : repasser à `publiable`.

---

## 2026-10-29T20:12Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Huitième paquet : Zenodo 23585999 (« AI Income Rights and the Identification of Declining Work », v0024 ; Python ; 56 Mo ; données SCF incluses, aucune inscription). Téléchargé (MD5 conformes), extrait par `python3 -I` (222 fichiers), image `replab-ai306` (Python 3.12.15 ; le README dit 3.12.14 ; numpy/scipy/pandas/matplotlib/mpmath identiques au lock). `verify_release.py --manifest` passed ; `run_all.py` : 39 programmes code 0 en moins de 3 min 21 s ; `verify_release.py` passed. Comparaison paquet livré contre régénéré (`compare_pkg_run.py`, `compare_csv.py`) : 89 fichiers réécrits, 50 identiques à l'octet, 39 différents (durées, empreintes, chaînes d'environnement, arrondis ; CSV : écart relatif max 9,58·10⁻¹⁴ ; une valeur de JSON hors tolérance 10⁻⁹/10⁻¹², `utility_optimizer_max_spending_difference` 1,01·10⁻⁸ contre 1,17·10⁻⁸, cause non établie). Rapport 8 `rapports/zenodo-23585999/RAPPORT.md` : *reproduit* / *paquet*, `brouillon`. Dossier inscrit (`bin/inscrit_dossier.sh`).

**Incidents.** `bin/registre.sh verifie` répond « ENTRÉE 64: journal/JOURNAL.md modifié depuis l'inscription » : le journal inscrit par le lanceur change à chaque session, ce qui rend la vérification fautive pour une entrée ancienne ; non traité (le lanceur gère le journal), à porter au relecteur et à la revue. Un `mkdir` via `bash -c` a été refusé (inutile : dossier déjà existant). Première version de `compare_pkg_run.py` limitée à 5 chemins par fichier ; remplacée par une version à tolérance absolue et 60 chemins, tous les logs de comparaison refaits avec la version finale.

**Bloqué.** Notification à l'auteur correspondant (art. 6) sans objet ici (*reproduit*) ; pour le rapport 7 (*divergent*) elle reste non envoyée, canal à décider par le propriétaire. Aucun BLOCAGE de conformité.

**Prochaine action.** Relecteur : relire le rapport 8 (nombres contre `comparaison_*.log`, `reecrits_identiques.log`) et statuer sur l'entrée 64 du registre. Auteur : paquet suivant ; éventuellement seconde exécution du 23585999 pour la répétabilité.

---

## 2026-10-29T20:02Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commit dcbed6c (auteur) : rapport zenodo-23585246 repassé en `brouillon`, nouvelle section « Répétabilité » ; contrôle contre `repet_1e-6.log`, `repet_1e-2.log`, `run2_vs_paquet_1e-6.log`, `lancement_run2.log`, `etat_run2_final.log`, `etat_run2_podman.log`. Tous les nombres concordent (104 628 cellules égales entre les deux exécutions ; mêmes décomptes au paquet ; sha256 VIX identique ; code 0 ; 1 h 15 min 53 s de CPU).

**Verdict de relecture.** Conforme, `brouillon` → `publiable` (divergent / paquet), aucune correction de nombre. Détail : `RELECTURE.md`. Registre 231 (RAPPORT), 232 (RELECTURE). Journal non inscrit (le lanceur s'en charge).

**Blocages.** Aucun BLOCAGE. Rien de contraire à CLAUDE.md dans les derniers commits. Rappel : la notification à l'auteur correspondant (art. 6, 14 jours) n'est toujours pas envoyée ; canal à décider par le propriétaire. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet suivant ; canal de notification à porter à la revue.

---

## 2026-10-29T20:00Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Relevé de `replab-oilecu-run2` : terminé, code 0 (`etat_run2_final.log`, `etat_run2_podman.log`). Comparaison par cellule 1re contre 2e exécution : 104 628 cellules sur 104 628 égales, à 10⁻⁶ et 10⁻² (`repet_1e-6.log`, `repet_1e-2.log`) ; 2e exécution contre paquet : mêmes décomptes que la 1re (`run2_vs_paquet_1e-6.log`). Section « Répétabilité » ajoutée au rapport 7, limites corrigées ; le rapport repasse à `brouillon` (contenu modifié après relecture, à relire). Dossier réinscrit. Le verdict *divergent*/*paquet* est inchangé ; la cause reste non établie.

**Incident mineur.** Premier appel de `capture.sh` avec `ssh` redoublé (code 255), comme les 27 et 28/10 ; refait correctement. Les écrans de `capture.sh` n'affichent que les 3 dernières lignes : lire le fichier.

**Bloqué.** Notification à l'auteur correspondant (art. 6) toujours non envoyée : canal à décider par le propriétaire. Aucun BLOCAGE de conformité.

**Prochaine action.** Relecteur : relire la section répétabilité, repasser à `publiable`. Auteur : paquet suivant ; éventuellement isoler la cause (VIX du millésime de l'article indisponible ? autre version de Python) — à juger au coût.

---

## 2026-10-28T20:10Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commit c888189 (auteur) : `lance_run2.sh`, `lancement_run2.log`, entrée de journal. Aucun rapport à l'état `brouillon` (sept rapports, tous `publiable`) : rien à passer ni à objecter.

**Verdict de relecture.** Sans objet (aucun brouillon). Conformité : seconde exécution en conteneur `--network none`, `--cap-drop all`, `--read-only`, seul `run2/` monté ; VIX réutilisé (sha256 identique dans le log), aucun téléchargement ; pas de secret. Rien de contraire à CLAUDE.md.

**Blocages.** Aucun BLOCAGE. Rappel : la notification à l'auteur correspondant du rapport 7 (art. 6, 14 jours) n'est pas envoyée ; canal à décider par le propriétaire. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : relever `replab-oilecu-run2`, section répétabilité ; question du canal de notification à la revue.

---

## 2026-10-28T20:06Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Rapport 7 (zenodo-23585246) déjà `publiable`. Lancement d'une seconde exécution détachée pour tester la répétabilité (réserve du relecteur) : `rapports/zenodo-23585246/lance_run2.sh`, même image, même paquet, **même fichier VIX que la 1re exécution** (sha256 identique, `lancement_run2.log`), conteneur `replab-oilecu-run2` (id 160f803cc324, lancé 20:05:36Z, ~2 h), résultats dans `~/work/z23585246/run2/` ; `run/` de la 1re exécution intact. Dossier réinscrit (`bin/inscrit_dossier.sh rapports/zenodo-23585246`).

**Non fait / bloqué.** Notification à l'auteur correspondant (art. 6) : non envoyée ; aucun canal d'envoi n'est prévu au dépôt et le mainteneur n'ouvre aucun compte. À décider avec le propriétaire (forme, canal). Aucun BLOCAGE de conformité.

**Prochaine action.** Cycle suivant : relever `replab-oilecu-run2` (`podman wait`, `podman logs` via capture.sh), comparer `run2/output/tables` à `run/output/tables` (`compare_tolerance.py`), ajouter la section répétabilité au rapport (par entrée nouvelle au registre) ; soumettre la question du canal de notification à la revue.

---

## 2026-10-28T20:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commit ef126d7 (auteur) : `rapports/zenodo-23585246/RAPPORT.md` (brouillon, *divergent*/*paquet*), contrôlé contre `comparaison_tolerance*.log`, `comparaison_tables.log`, `run_conteneur.log`, `etat_6.log`, `grep_seed.log`, `diag_vix.log`, `lance_run.sh`. Tous les nombres concordent avec leurs logs et commandes ; verdict justifié (écart mesuré, cause déclarée non établie, rien d'inféré) ; aucun mot interdit ni intention prêtée.

**Verdict de relecture.** Conforme, `brouillon` → `publiable`, aucune correction de nombre. Détail : `RELECTURE.md`. Registre 128 (RAPPORT), 129 (RELECTURE). Réserves non bloquantes : `compare_tolerance.py` typé `log` ; répétabilité non testée (une seconde exécution renforcerait le verdict). **À faire avant publication : notification à l'auteur correspondant, délai 14 jours (art. 6) ; rien n'a été envoyé.**

**Blocages.** Aucun BLOCAGE. Journal et commits récents sans action contraire à CLAUDE.md (conteneur sans réseau, VIX téléchargé hors conteneur). Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : préparer la notification (art. 6) pour décision du propriétaire sur la forme ; éventuellement seconde exécution ; paquet suivant.

---

## 2026-10-28T20:00Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Relevé de l'exécution détachée de zenodo-23585246 : conteneur 87ad71e2299a terminé, code 0 (`etat_6.log`), sortie complète `run_conteneur.log`. Comparaison des 31 tables CSV régénérées à celles du paquet : octet à octet, 31 sur 31 diffèrent (`compare_tables.sh`), mais cette comparaison est trop sévère (x13 : cellules égales, octets différents, cause non relevée). Comparaison par cellule (`compare_tolerance.py`) : 104 628 cellules, 47 958 égales, 12 121 dans 10⁻⁶, 44 549 hors ; 6 381 hors 10⁻², 3 170 hors 10⁻¹. Tables déterministes concordantes (descriptives, racines unitaires, sélection de retards, X-13) ; tables dépendant de tirages divergentes malgré des `set.seed`. Cause non établie (VIX, versions, tirages non départagés). Rapport `rapports/zenodo-23585246/RAPPORT.md`, `brouillon`, verdict proposé **divergent** / portée **paquet**. Dossier inscrit par `bin/inscrit_dossier.sh`.

**À examiner par le relecteur.** (1) Le seuil 10⁻⁶ est mon choix ; trois seuils sont donnés. (2) Verdict *divergent* alors que la cause est inconnue : le rapport le dit et n'infère rien. (3) Si publiable, la notification à l'auteur correspondant (art. 6, 14 jours) est à faire après relecture ; rien n'a été envoyé. (4) `compare_tolerance.py` est inscrit sous le type `log` (l'outil ne type que `.sh`/`.R`) ; à corriger par entrée nouvelle si le relecteur le juge utile.

**Incidents.** Premier appel de `capture.sh` avec `ssh` redoublé (code 255, `etat_6.log` écrasé par la reprise correcte) — même erreur que le 27/10. Un chemin erroné tenté en écriture (`/home/replique`), refusé, sans effet. `registre.sh verifie` signale l'entrée 64 (journal modifié depuis l'inscription) : attendu, le lanceur réinscrit le journal.

**Non fait.** Aucune répétition de l'exécution (2 h) pour tester la répétabilité ni isoler la cause (VIX / versions) ; figures et `paper/_tables` non comparées.

**Prochaine action.** Relecteur : juger le rapport 7. Auteur : éventuellement une seconde exécution détachée (même image, même entrée) pour tester la répétabilité, puis paquet suivant.

---

## 2026-10-27T20:30Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commit 5f8a5bb (auteur, zenodo-23585246) et journal. Aucun rapport à l'état `brouillon` : les six rapports existants sont `publiable`, le septième n'a pas de RAPPORT.md (exécution détachée en cours). Rien à passer ni à objecter.

**Contrôle de conformité.** `lance_run.sh` : conteneur `--network none`, `--cap-drop all`, `--read-only`, seul le répertoire de travail copié monté ; le VIX (FRED, accès public direct) est téléchargé sur l'hôte par `curl` seul, hors du conteneur ; réseau de construction limité à apt et CRAN. Aucun BLOCAGE. Point à traiter dans le rapport : l'empreinte du VIX diffère de celle de l'article, cause non établie ; le dire sans inférer.

**Prochaine action.** Auteur : relever l'exécution, comparer les tables, rédiger le rapport.

---

## 2026-10-27T20:20Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Septième paquet : Zenodo 23585246 (« Oil Price Shocks, Sovereign Risk, and Bank Interest Rates Under Full Dollarization », Équateur ; R + Python ; 4,8 Mo ; données incluses sauf le VIX, en accès public direct sur FRED, donc dans le périmètre de l'art. 1). Choisi après lecture de deux fiches (23381101 écarté : microdonnées FaedPyme non redistribuées, jeu synthétique seulement ; 23585999 non retenu, plus lourd). MD5 conforme, extrait par `python3 -I` (129 fichiers). Image `replab-oilecu` construite (réseau : apt et CRAN, construction seulement) : R 4.6.1, seasonal 1.11.0, x13binary 1.1.61.2, urca 1.3.4, strucchange 1.6.0, ggplot2 4.0.3 (identiques à ceux de l'article), Python 3.14.8, pandas 2.3.3 (article : 3.0.5), numpy 2.4.6 (2.5.2). VIX téléchargé sur l'hôte par `curl` seul (les deux premiers lancements ont échoué : HTTP/2 puis agent utilisateur ; en-tête FRED `observation_date` renommé en `date` comme le fait `01_fetch_fred.py`) ; empreinte du VIX jusqu'au 22/09 : **DIFFÈRE** de celle de l'article (`check_vix.log`), alors que le nombre d'observations est identique (9 279, `diag_vix.log`) ; cause non établie, à dire dans le rapport.

**Exécution en cours (détachée, ~2 h prévues).** Conteneur `replab-oilecu-run` (id 87ad71e2299a, lancé à 20:16Z, `lancement_4.log` et `etat_5.log` ; l'id 9d71a9cbdd9e est celui du 3ᵉ lancement, échoué à l'étape 02 ; le 2ᵉ script de lancement, `lancement_2.log`, s'est arrêté seul en code 1 sans toucher au conteneur) sur sd-92569, sans réseau, `bash run_all.sh` avec `SKIP_DOWNLOAD=1 PY=python3`. Répertoire : `~/work/z23585246/run/` (copie inscriptible du paquet). Relever : `podman ps -a`, `podman logs replab-oilecu-run > …` via `bin/capture.sh`, `podman wait`/`podman inspect` pour le code de sortie. À comparer ensuite : `run/output/tables/*.csv` contre `pkg/…/output/tables/*.csv` fournis (copie intacte dans `pkg/`). Les logs `etat_*.log` du dossier sont des relevés intermédiaires.

**Pas de rapport encore** : aucun résultat n'a été produit. Dossier non inscrit au registre (fichiers encore à venir) ; le prochain cycle inscrit tout par `bin/inscrit_dossier.sh`. Dossier `rapports/zenodo-23381101/` : fiche seule (non retenu).

**Incidents.** Deux lancements ratés (curl HTTP/2 ; en-tête VIX), conteneur du 1er lancement supprimé (`arret_1.log`) ; un `cp` refusé (remplacé par un fichier écrit à la main, `extrait.sh`) ; un `curl` en arrière-plan a tourné quelques minutes (délai de 120 s × reprises), sans effet.

**Prochaine action.** Auteur (cycle suivant) : relever le résultat, comparer les tables, rédiger le rapport (portée *paquet*, mention des écarts de versions Python et du VIX), inscrire le dossier.

---

## 2026-10-27T20:10Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 90b05e7 et 10cceb6 (session auteur du 27/10 soir) : `rapports/zenodo-23595707/RAPPORT.md` (brouillon), contrôlé contre `executions.log`, `readme.log`, `results_verification.csv`, logs `tc` et `nft`. Tous les nombres concordent avec leurs logs ; verdict *reproduit*/*paquet* justifié et borné dans les Limites ; aucun mot interdit ni intention prêtée.

**Verdict de relecture.** Conforme, `brouillon` → `publiable`. Correction de forme : deux comptages de lignes de CSV sans log retirés, aucun nombre de résultat touché. Détail : `RELECTURE.md`. Registre 82 (`correction`), 83 (relecture) ; `verifie` OK. Réserve : la journalisation nft est limitée à 20 connexions/s ; `bin/liste_zenodo.py` inutilisé reste à retirer par entrée nouvelle.

**Blocages.** Aucun BLOCAGE. Le constat de procédure du 26/10 est bien levé par les relevés `tc` et `nft`. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet suivant.

---

## 2026-10-27T20:10Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** (1) Politique de sortie de sd-92569 relevée sous `sudo` (`sudo tc qdisc show`, `sudo nft list ruleset`) : `tbf 200Mbit` sur enp1s0f0, table nft `inet replab` qui journalise les nouvelles connexions de l'uid 1001, ports 25/465/587 refusés (logs `rapports/zenodo-recherche-20261027-{tc,nft}.log`) ; le constat de procédure du 26/10 est levé. (2) Sixième paquet : Zenodo 23595707 (QSurvDiag, Python bibliothèque standard, 10,9 Mo, données incluses) choisi dans la page 2 de la recherche « replication package » ; MD5 conforme, extrait par `python3 -I`. Les quatre commandes du README exécutées en conteneur `python:3.12-slim` sans réseau, paquet en lecture seule : intégrité + RFC 3161 OK, `reproduce` 399 contrôles (MATCH 297, PARTIAL 100, analytique non exécuté 2), conformité 41/41, 41/41, 22/22, `reproduce_experiments` 84 (MATCH 70, PARTIAL 6, analytique non exécuté 8), tous codes 0, 7 s. Rapport `rapports/zenodo-23595707/RAPPORT.md`, `brouillon`, verdict proposé *reproduit*/*paquet*. Registre 76-81 ajouté (le dossier du rapport est inscrit jusqu'à l'entrée 75 ; `verifie` OK, 81 entrées).

**À examiner par le relecteur.** (1) Portée *paquet* alors que le paquet relit des enregistrements archivés (même question que le rapport 4, déjà au dossier de la revue n° 3) ; le rapport le dit. (2) Le niveau analytique (10 contrôles sur 483) n'a pas été exécuté (QUTest, pip, clones GitHub) : le rapport le déclare. (3) Aucune comparaison à l'article.

**Incidents.** Premier appel de `capture.sh` avec `ssh` redoublé (code 255, log conservé et inscrit). `bin/liste_zenodo.py` écrit puis non utilisé (python refusé hors sandbox) ; je n'ai pas pu le supprimer (`rm` refusé), il est inscrit au registre tel quel (entrée 80) : le relecteur peut le retirer par une entrée nouvelle. `rapports/zenodo-23591167/fichiers.json` : fiche d'un autre candidat, non retenu (relief et MDS, dépendances lourdes et DEM non redistribué).

**Prochaine action.** Relecteur : juger le rapport 6. Auteur : paquet suivant ; éventuellement le niveau analytique de 23595707 (réseau vers GitHub et PyPI à nommer).

---

## 2026-10-27T09:30Z — relève par le mainteneur (session interactive) avec le propriétaire

Première nuit à quatre sessions : deux rapports écrits et passés `publiable` le soir même (23511350, 23624408) ; cinq rapports au total ; 2,36 $ estimés pour la nuit, 7,4 $ depuis le début.

**Registre.** `verifie` échouait sur l'entrée 61 (journal inscrit en cours de session, puis modifié par l'entrée du relecteur — même défaut que le 26/10, entrée 22). Correction de conception : le lanceur inscrit `journal/JOURNAL.md` après chaque session qui l'a modifié ; les sessions ne l'inscrivent plus. Entrée `journal` ajoutée ci-après pour rétablir la chaîne ; rien d'ancien modifié.

**Consigne ajoutée (prompt auteur).** Exécutions de plus d'une heure : détachées sur l'exécuteur, relevées au cycle suivant. Motif : le garde-fou de deux heures tue la session, pas le conteneur (défaut du `timeout` noté le 17/10).

**Au dossier de la revue n° 3** (avec « hors paquet ») : portée *paquet* quand la suite du paquet relit des résultats conservés sans les régénérer (rapport 4, question du relecteur du 26/10 20:45Z).

**Prochaine action.** Auteur : paquet suivant ; outiller l'exécution détachée avant le premier paquet long.

---

## 2026-10-26T21:35Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 4086f9f..HEAD : session auteur du 26/10 soir (cfff8bf) : `rapports/zenodo-23624408/RAPPORT.md` (brouillon), logs, registre 34-61. Nombres contrôlés contre `run_all.log` (code 0, 3 928 s, étapes, dix PASS, ni warning ni error), `comparaison.log` (26/26/1), `ecarts.log` (5,9e-10 ; 7,55e-14 ; 1,06e-10 ; 8,15e-13 hors cellules proches de zéro), `diffs.log` (M, T, H, n). Aucune intention prêtée, aucun mot interdit (recherche par motifs).

**Verdict de relecture.** Conforme, état `brouillon` → `publiable`. Une correction de forme (renvoi `diffs.log` ligne 59 → 60), aucun nombre touché. *Reproduit*/*paquet* acceptable car le rapport dit que 26 fichiers ne sont pas identiques à l'octet et ne donne la cause que comme hypothèse. Détail : `RELECTURE.md`. Registre : 62 (`correction:34`), 63 (relecture) ; `verifie` OK, 63 entrées.

**Blocages.** Aucun BLOCAGE. Sur le « constat de procédure » de l'auteur (politique de sortie) : le journal du 17/10 (rectification) établit que la limite de débit (`tc tbf 200Mbit`, via `replab-egress.service`) et la journalisation (table nft `inet replab`) existent ; `politique_sortie.log` n'interroge que iptables, sans `tc` ni nft, d'où l'absence apparente. Pas de manquement, mais la même erreur de méthode qu'au 17/10 (constat d'absence sans le bon relevé) ; l'auteur peut la lever avec `sudo tc qdisc show` et `sudo nft list ruleset`. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet suivant.

---

## 2026-10-26T21:30Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Cinquième paquet : Zenodo 23624408 (DEA-MP/H, R, 122 ko ; microdonnées du recensement brésilien non incluses mais en accès public direct sur ftp.ibge.gov.br, donc dans le périmètre de l'art. 1). Téléchargé, MD5 conforme, extrait par `python3 -I`. Image `replab-deamph` (r-base + data.table, lpSolve, rDEA ; réseau à la construction seulement). Microdonnées (≈ 2,2 Go) téléchargées sur l'hôte par `curl` seulement (`telecharge_ibge.sh`), puis `Rscript run_all.R` en conteneur sans réseau : code 0, 3 928 s, dix contrôles du paquet PASS. 51 CSV de résultats comparés aux fichiers fournis : `inputs_sha256.csv` identique, 26 fichiers sur 53 identiques à l'octet, 26 différents à l'arrondi flottant près (écart relatif ≤ 8,2e-13 hors cellules proches de zéro ; plus grand écart absolu 5,9e-10). Rapport `rapports/zenodo-23624408/RAPPORT.md`, `brouillon`, verdict proposé *reproduit*/*paquet*. Script `bin/inscrit_dossier.sh` (inscription groupée d'un dossier au registre).

**À examiner par le relecteur.** (1) *Reproduit* avec des fichiers qui ne sont pas identiques à l'octet : le rapport l'écrit en toutes lettres et chiffre les écarts ; la cause (plateforme numérique) n'est qu'une hypothèse, notée comme telle. (2) Les fichiers IBGE ont été placés par `curl` hors du code du paquet (voie « à la main » du README). (3) `tests/expected_values.csv` est absent de l'archive : aucune comparaison avec les valeurs de l'article.

**Constat de procédure.** La politique de sortie vue sur sd-92569 (`politique_sortie.log`) ne montre que le blocage des ports 25, 465 et 587 ; je n'ai pas cherché de limitation de débit ni de journalisation des destinations (autre chaîne ou `tc`), et le code du paquet n'avait de toute façon aucun réseau. À confirmer par le propriétaire ou à contrôler à la prochaine session (art. 4).

**Non fait.** Aucun contact extérieur. Pas de comparaison au manuscrit. Coût estimé : voir USAGE.tsv.

**Prochaine action.** Relecteur : juger le rapport 5. Auteur : paquet suivant ; vérifier la politique de sortie (`sudo tc qdisc show`, règles de journalisation) avant le suivant.

---

## 2026-10-26T20:45Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 58377c7..HEAD : session auteur du 26/10 (48e147a) : `rapports/zenodo-23511350/RAPPORT.md` (brouillon), logs, registre 24-31. Contrôlé contre les logs : code 1 et message NumPy (`executions.log` l. 7, 14), NumPy 2.5.4 (`executions_numpy.log` l. 12, 22), manifeste 138, médianes appariées et graine 20260922 (l. 24-29), `TOTAL=97 PASS=97`, `ARM64_TOTAL=72 PASS=72` (l. 140, 214), `graphs_tested=1099` (l. 215), `trials_per_parameter` 10000 (l. 221), `DFAR_FULL_VERIFICATION_PASS` et code 0 (l. 376-377), citations du guide (`guide.log` l. 58-64, 134-143). Chaque nombre est relié à sa commande ou à son log ; aucune intention prêtée, aucun mot interdit (recherche par motifs faite).

**Verdict de relecture.** Conforme, état passé de `brouillon` à `publiable`. Question posée par l'auteur : *reproduit*/*paquet* est acceptable parce que l'en-tête et les Limites disent que la suite relit des résultats bruts conservés et ne régénère ni les mesures de temps, ni C, ARM64, Go ; seuls les intervalles BCa et les contrôles structurels/mutations sont recalculés. Point à trancher en revue n° 3 : la portée *paquet* (art. 6 ter, « régénérés par son code ») est ici lue largement ; une convention pour ce cas serait utile.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée (exécutions en conteneur, réseau seulement pour la construction vers PyPI, aucun contact extérieur). Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet suivant à données incluses.

---

## 2026-10-26T20:10Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Quatrième paquet : recherche Zenodo (`rapports/zenodo-recherche-20261026/recherche.json`), retenu 23511350 (DFAR / ML-KEM, 407 ko, données incluses, Python seul pour la commande d'entrée). Téléchargé, MD5 conforme, extrait par `python3 -I` sur l'hôte (aucun code du paquet hors conteneur). `python3 run_verification_suite.py` en conteneur sans réseau : échoue sans NumPy (code 1, dépendance déclarée au guide) ; avec une image dérivée (NumPy 2.5.4 depuis PyPI, construction seulement) : `DFAR_FULL_VERIFICATION_PASS`, 97 + 72 contrôles. Rapport `rapports/zenodo-23511350/RAPPORT.md`, `brouillon`, verdict proposé *reproduit*/*paquet* ; limites explicites : la suite relit des résultats bruts conservés, ne régénère pas les mesures (C, ARM64, Go non relancés).

**Défaut de ma part.** La commande de téléchargement comportait un `curl -O` superflu (fichier inutilisé laissé dans `~/work/z23511350/zip/`) ; conservée telle quelle au log et signalée au rapport.

**Non fait.** Pas de reconstruction C/OpenSSL (hors de ce que la commande d'entrée exige). Aucun contact extérieur. Coût estimé : voir USAGE.tsv.

**Prochaine action.** Relecteur : juger si *reproduit* est le bon mot vu la limite « relecture de résultats bruts » (sinon l'écrire en objection). Auteur : paquet suivant.

---

## 2026-10-26T10:30Z — revue hebdomadaire n° 2 (propriétaire et mainteneur, session interactive)

Deux amendements acceptés, CLAUDE.md en v2.2 : article 1 (données non incluses ni publiques hors périmètre ; aucun formulaire, aucun compte) ; article 5 (sessions entre 21 h et 9 h, cycles enchaînés, quatre par nuit, fenêtre commune au parc). Mise en œuvre : `bin/nuit.sh` lancé par cron à 21 h, enchaîne auteur, relecteur, auteur, relecteur ; refuse de commencer une session après 8 h 30. Les deux lignes de cron précédentes sont retirées.

État : trois rapports `publiable` (23439616 reproduit/paquet ; 23437544 et 23607297 inexécutable/paquet), 23 entrées au registre, test d'altération inscrit, 22 sessions non interactives, 5,0 $ estimés.

Au dossier de la revue n° 3 : convention pour le cas « inexécutable tel que livré, reproduit après une correction minimale documentée » (rapport 3), déjà pratiquée par l'auteur sous la forme d'une section « mesure hors paquet » ; à écrire.

**Prochaine action.** Auteur : paquet suivant. Première nuit à quatre sessions : 26/10, 21 h.

---

## 2026-10-26T06:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 47045fd..HEAD : session auteur du 25/10 (96105a0) : logs `readme.log`, `fiche_zenodo.json`, `podman_images.log`, RAPPORT.md de `zenodo-23607297`, registre 14-20. Objections 1-3 levées : citations du README retrouvées dans `readme.log` (lignes 21, 25-33, 41), titre et créateur « Anonymous » dans `fiche_zenodo.json`, image dans `podman_images.log` (datation du 25/10 signalée au rapport). Nombres de la section B inchangés, tous dans `executions.log`. Verdict *inexécutable*/*paquet* justifié ; aucune intention prêtée, aucun mot interdit.

**Verdict de relecture.** Conforme. État passé de `brouillon` à `publiable`. Registre : entrée 21 (`correction:20`, RAPPORT.md). `verifie` OK.

**Erreur de ma part.** Dans l'entrée 21, le numéro après `correction:` (20) désigne l'entrée du test d'altération ; l'entrée remplacée du rapport est la 14. Entrée 22 (`correction:21`, JOURNAL.md) inscrite trop tôt, avant la rédaction de cette note ; le journal est réinscrit après cette note (entrée suivante). Aucune modification de l'existant.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet suivant à données incluses. Tête à témoigner.

---

## 2026-10-25T20:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Objections 1-3 du relecteur sur `zenodo-23607297` levées : `readme.log` (`cat` du README sur sd-92569, chemin `pkg/README.md`), `fiche_zenodo.json` (API Zenodo : titre, créateur « Anonymous »), `podman_images.log` ; RAPPORT.md renvoie à ces logs (lignes citées), reste `brouillon`, verdict inchangé. Précision portée au rapport : `podman images` a tourné le 25/10, après les exécutions. Registre : entrée 14 (`correction:12`, rapport), 15-17 (logs), 18 (RELECTURE.md), 19-20 (`bin/test_alteration.sh`, puis `correction:19`). `verifie` OK, 20 entrées, tête c264cde2…1a721 (`bin/registre.sh tete`).

**Incident.** Une première capture de `readme.log` avec un mauvais chemin (`work/z23607297/README.md`, code 1) a été écrasée par la bonne ; aucune trace de la première hors de cette note. Autre défaut trouvé : `bin/test_alteration.sh` ne copiait que `registre.sh`, donc la copie intacte échouait dès que le script était lui-même inscrit ; corrigé (copie de tout `bin/`), réinscrit, `TOUT PASSE` (4 cas).

**Non fait.** Paquet suivant non cherché (priorité à lever les objections). Aucun contact extérieur.

**Prochaine action.** Relecteur : vérifier les trois remèdes et passer le rapport 3 à `publiable` ou objecter. Auteur : paquet suivant à données incluses, sans inscription.

---

## 2026-10-25T06:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 03bc585..HEAD : session auteur du 24/10 (50183e8) : rapport `zenodo-23607297` (brouillon), registre entrées 12-13. Nombres de la section B et code de sortie A reliés à `executions.log` ; verdict *inexécutable*/*paquet* justifié ; aucune intention prêtée, aucun mot interdit.

**Verdict de relecture.** Non conforme sur un point : citations du README, titre/« créateur anonyme » et `podman images` sans log ni commande (art. 6). État laissé `brouillon` ; objections précises dans `rapports/zenodo-23607297/RELECTURE.md` (remède : capturer `cat README.md` et la fiche Zenodo). `verifie` : OK, 13 entrées.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : lever les objections 1-3 du rapport 3, inscrire RELECTURE.md au registre, inscrire le test d'altération, paquet suivant.

---

## 2026-10-24T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Recherche d'un paquet à données incluses : API Zenodo interrogée depuis sd-92569 (`recherche2.json`, jeu « replication package », plus récents). Retenu : 23607297 (4 fichiers, 8 ko, bibliothèque standard seule). Téléchargé (`telechargement.log`, sommes MD5 = celles de Zenodo), exécuté en conteneur sans réseau (`lance_executions.sh` → `executions.log`). Résultat : tel que livré, le script échoue (`FileNotFoundError`, chemin Windows `D:/…` en dur, code 1) ; avec une copie dont seule cette ligne change, `ALL PASS` et valeurs du README. Rapport `rapports/zenodo-23607297/RAPPORT.md`, `brouillon`, verdict proposé *inexécutable*, portée *paquet*. Registre : entrées 12 (rapport) et 13 (executions.log) ; `verifie` OK, 13 entrées, tête 87d03f22…4cbd.

**Questions pour le relecteur.** *Inexécutable* ou *reproduit* ? J'ai retenu le premier (la commande documentée échoue) et signalé la mesure B comme hors paquet. Note : `fichiers.json`, `recherche*.json` sont dans `rapports/` (sorties de capture.sh) ; `recherche2.json` pèse ~140 ko, inutile à inscrire.

**Bloqué.** Rien. Le test d'altération reste à inscrire au registre (non fait). Aucun contact extérieur.

**Prochaine action.** Relecteur : relire le rapport 3. Auteur : inscrire le test d'altération ; paquet suivant.

---

## 2026-10-24T05:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits c5be4bf..HEAD : session auteur du 23/10 (59d527a) : `bin/test_alteration.sh`, rapport `zenodo-23437544` (brouillon), registre entrée 10. Rapport : chaque nombre/fait relié à son log et à sa commande (11 598 × 471 dans `readme_reproduce.log`, `find` vide dans `recherche_csv.log`, champs obligatoires et `browse.php` dans `liens_donnees4_page_complete.log`) ; verdict *inexécutable*, portée *paquet*, justifié ; aucune intention prêtée, aucun mot interdit ; limites honnêtes (GET seulement, aucun POST).

**Verdict de relecture.** Conforme. État passé de `brouillon` à `publiable`. Registre : `correction:5` (entrée 11). `bin/test_alteration.sh` lancé : TOUT PASSE (4 cas). `verifie` avant ma modification : OK, 10 entrées.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : paquet à données incluses ; inscrire le test d'altération au registre. Tête à témoigner.

---

## 2026-10-23T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** (1) `bin/test_alteration.sh` écrit et lancé : copie hors de l'arbre (`mktemp -d`, nettoyée), 4 cas — copie intacte OK ; fichier inscrit modifié, date d'une entrée réécrite, entrée supprimée : `verifie` échoue chaque fois. « TOUT PASSE ». Limite non couverte (déjà connue) : altération d'une version antérieure d'un fichier réinscrit. (2) 23437544 : page de formulaire lue en entier (GET seulement, `liens_donnees4_page_complete.log`) : champs obligatoires, `browse.php` seulement après POST ; CSV absent du paquet (`recherche_csv.log`). Rapport `rapports/zenodo-23437544/RAPPORT.md`, état `brouillon`, verdict *inexécutable*, portée *paquet*, motif posé par le propriétaire. Inscrit au registre (entrée 10).

**Bloqué / non fait.** Paquet suivant à données incluses non cherché : pas fait cette session (priorité au relecteur sur le rapport 2). Le test d'altération n'est pas encore inscrit au registre.

**Prochaine action.** Relecteur : relire le rapport 2 (à passer `publiable` ou à bloquer) et lancer `bash bin/test_alteration.sh`. Auteur : chercher un paquet Zenodo à données incluses, sans inscription. `verifie` doit être relancé après la relecture.

---

## 2026-10-23T08:50Z — décisions du propriétaire (session interactive avec le mainteneur)

Réponses aux deux questions posées par l'auteur le 2026-10-22T19:05Z.

**Test d'altération.** Aucune ouverture du lanceur : tout script versionné dans `bin/` est exécutable par l'auteur et le relecteur. Le test s'écrit comme un script (`bin/test_alteration.sh` : copie du dépôt hors de l'arbre, falsification d'un fichier inscrit, `verifie` doit échouer, nettoyage), se versionne, se lance. Consigne ajoutée au prompt auteur.

**Formulaire de données (zenodo-23437544).** Refus. Le projet ne remplit aucun formulaire et n'ouvre aucun compte chez un tiers. Règle : seuls les paquets dont les données sont incluses ou en accès public direct sont dans le périmètre ; les autres sont hors périmètre pour l'instant — amendement de l'article 1 proposé pour la revue n° 2. Pour 23437544 : si la lecture complète de la page établit que les données sont soumises à inscription, l'auteur peut poser *inexécutable*, portée *paquet*, motif « données non incluses, accès soumis à inscription » ; sinon, paquet écarté sans rapport. Raisons du propriétaire et du mainteneur : identité et conditions d'utilisation engagées auprès d'un tiers ; réplication non vérifiable par un lecteur sans la même inscription ; échantillons malveillants sur une machine soumise à la règle des 48 h de l'hébergeur.

**Prochaine action.** Auteur : test d'altération par script ; conclusion sur 23437544 ; paquet suivant à données incluses.

---

## 2026-10-23T05:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 68083f8..HEAD : session auteur du 22/10 (59bf5ba) : journal et quatre logs d'accès sous `rapports/zenodo-23437544/` (consultation de la page de données, rien rempli ni envoyé). Aucun `RAPPORT.md` à l'état `brouillon` : `zenodo-23439616` est `publiable` et inchangé ; `zenodo-23437544` n'a pas de rapport (pas de verdict posé, ce qui est cohérent avec l'art. 6). `bash bin/registre.sh verifie` : OK, 9 entrées, tête 263a441ef106e7234f4246d14facaafc652887544ef49ad4a07c9d7dc73a48e2.

**Verdict de relecture.** Rien à relire côté rapports. L'arrêt de l'auteur devant le formulaire est conforme aux art. 3 et 6 (contact avec un tiers non prévu, décision du propriétaire).

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Propriétaire : trancher les deux questions posées par l'auteur (répertoire fixe pour le test d'altération ; formulaire de données). Sinon l'auteur choisit un paquet autonome.

---

## 2026-10-22T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** `bash bin/registre.sh verifie` → OK, 9 entrées, tête 263a441e…48e2 (rapport 1 `publiable`, rien à corriger). Second paquet : les répertoires de `~/work` sur sd-92569 (`ls work`) montrent 18592832, 21342547, 20581409 (écartés le 17/10) et 23437544, jamais cité au journal. Candidat 23437544 (Android malware, CICMalDroid2020) : le zip contient les scripts et les CSV de résultats, mais pas les données (`README_reproduce.txt`). La page UNB (`acces_donnees.log`, HTTP 200) renvoie vers `http://cicresearch.ca/CICDataset/MalDroid-2020/`, dont le contenu commence par une liste de pays (`liens_donnees3.log`) : formulaire d'inscription, apparemment.

**Bloqué / non fait.** (1) Test d'altération du registre : `cp -r` du dépôt vers `/tmp` refusé par Bash (mode « don't ask »), non contourné. (2) Second paquet : obtenir les données exigerait de remplir un formulaire au nom du projet, soit un contact avec un tiers non prévu à l'art. 6 (décision du propriétaire, art. 3) ; je m'arrête là, aucun rapport créé. Je n'ai pas vu le formulaire en entier (3000 premiers octets seulement), c'est une hypothèse.

**Prochaine action.** Propriétaire : autoriser `cp -r` vers un répertoire fixe hors dépôt pour le test d'altération, et dire si un formulaire de données peut être rempli par le projet ; sinon l'auteur choisit un paquet autonome (données incluses) parmi de nouveaux enregistrements Zenodo. Un verdict *inexécutable* pour 23437544 n'est pas posé : il faudrait d'abord établir que les données sont inaccessibles sans inscription.

---

## 2026-10-22T05:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 0f5dfdb..HEAD : correction:2 au registre (b5440a1), témoin Drive dans `bin/session.sh` (05deab9, conforme à l'art. 4/5 : copie de fichier seulement), prompts. `RAPPORT.md` de `zenodo-23439616` inchangé depuis ma relecture du 2026-10-21 (aucun nombre touché).

**Verdict de relecture.** Rapport conforme (verdict *reproduit*, portée *paquet*, nombres reliés à leurs logs, ni intention prêtée ni mot interdit). État passé de `brouillon` à `publiable`. Registre : `correction:3` (RAPPORT.md) et `correction:4` (RELECTURE.md, note de cinquième relecture) ajoutées ; `bash bin/registre.sh verifie` → OK, 9 entrées, tête 263a441ef106e7234f4246d14facaafc652887544ef49ad4a07c9d7dc73a48e2. Tête à témoigner.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée. Rien exécuté, aucune connexion à sd-92569.

**Prochaine action.** Auteur : test d'altération (répertoire fixe hors dépôt si `mktemp` reste refusé), puis choix du second paquet. Limite de `verifie` (altération d'une version antérieure non détectée) toujours à publier dans `registre/LISEZMOI.md`.

---

## 2026-10-21T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** `bash bin/registre.sh verifie` échouait au départ : « ENTRÉE 2: RELECTURE.md modifié depuis l'inscription ». Cause : le relecteur a réécrit `RELECTURE.md` (commit d3ebba4, légitime) après l'inscription n° 2. Corrigé par une entrée nouvelle, sans toucher aux anciennes : `ajoute correction:2 rapports/zenodo-23439616/RELECTURE.md` (entrée 7). `verifie` → « OK: 7 entrées, tête 38161882c82c485fc3cf3ef261a0542f60d0be2afd81059101a1e4dbf2acdb76 ». Tête à témoigner.

**Constaté.** Toute édition par le relecteur d'un fichier inscrit fait échouer `verifie` tant qu'une correction n'est pas ajoutée ; c'est le comportement voulu, mais il faut une session avec Bash. `RAPPORT.md` reste à `brouillon` : seul le relecteur le passe à `publiable`, et ce changement exigera une entrée `correction:3` (à ajouter après lui, par l'auteur ou le relecteur).

**Bloqué / non fait.** Test d'altération sur copie : `mktemp -d` refusé par Bash (mode « don't ask »), non contourné. Témoin Drive : à la charge du propriétaire. Second paquet non commencé : le rapport 1 n'est pas encore `publiable`.

**Prochaine action.** Relecteur : passer `RAPPORT.md` à `publiable`, puis `ajoute correction:3 …RAPPORT.md` et `verifie`. Auteur ensuite : test d'altération (dans un répertoire fixe hors dépôt si `mktemp` reste refusé, à autoriser sinon), puis choix du second paquet.

---

## 2026-10-21T05:05Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits 2d9c293..0f5dfdb : portée *paquet* dans `zenodo-23439616` (seule ligne de verdict et une ligne de Limites changées, aucun nombre), `bin/registre.sh` (`verifie` ne compare que la dernière inscription d'un chemin), `registre/chaine.tsv` (entrée 6 `correction:1`). `bash bin/registre.sh verifie` : OK, 6 entrées, tête d91703516ada8ca105fbb2600a65d01759d770b22165195e202c9c06d9c161f9. Rien exécuté d'autre.

**Verdict de relecture.** Rapport conforme (verdict *reproduit*, portée *paquet*, nombres tous déjà reliés à leurs logs, ni intention ni mot interdit). État laissé à `brouillon` : Bash a été refusé en cours de session, je n'ai pas pu inscrire la correction:2 au registre, et passer à `publiable` sans l'inscrire ferait échouer `verifie`. Détail et marche à suivre dans `RELECTURE.md`. Limite de `registre.sh` relevée (altération d'une version antérieure non détectée par `verifie`, seulement par git) : à publier dans `registre/LISEZMOI.md`.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée.

**Prochaine action.** Session avec Bash : passer l'état à `publiable`, `ajoute correction:2`, `verifie`. Auteur ensuite : test d'altération, témoin Drive, second paquet.

---

## 2026-10-20T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Portée *paquet* ajoutée à côté du verdict de `zenodo-23439616` (art. 6 ter), avec renvoi aux Limites. Comme le texte du rapport a changé, l'état repasse à `brouillon` : seul le relecteur le remettra à `publiable`, après relecture de cette seule ligne. `bin/registre.sh` : `verifie` ne compare au fichier que la dernière inscription d'un chemin ; nouveau type `correction:<n>`. Avant le changement, `verifie` échouait bien sur RAPPORT.md modifié (entrée 1) ; après `ajoute correction:1 …RAPPORT.md` : « OK: 6 entrées, tête d91703516ada8ca105fbb2600a65d01759d770b22165195e202c9c06d9c161f9 ». `registre/LISEZMOI.md` mis à jour.

**Bloqué / non fait.** Test d'altération sur copie : Bash refusé (commande composée avec mktemp). Témoin Drive : toujours à la charge du propriétaire (rclone). Second paquet non commencé : le rapport 1 n'est plus `publiable`, et la correction du registre est à relire d'abord. Modification de `bin/registre.sh` (code de confiance) à relire par le relecteur.

**Prochaine action.** Relecteur : vérifier la ligne de portée, `bash bin/registre.sh verifie`, relire le diff de `registre.sh`, repasser le rapport à `publiable`. Auteur ensuite : test d'altération, puis choix du second paquet.

---

## 2026-10-20T10:25Z — revue hebdomadaire n° 1 (propriétaire et mainteneur, session interactive)

Trois amendements proposés, trois acceptés : article 4 (redirection 127.0.0.1), article 6 ter (portée du verdict), régularisation de l'étape 4 de l'ordre des opérations. CLAUDE.md passe en v2.1 ; historique complété. Hors ordre du jour, pour information : dix sessions non interactives depuis le 17/10, 2,3 $ estimés, un rapport publiable, trois sessions perdues et consignées.

**Prochaine action.** Auteur : porter la portée *paquet* sur le rapport zenodo-23439616 (une ligne à côté du verdict, nouvelle entrée de registre, l'ancienne n'étant pas modifiée) ; puis second paquet. Propriétaire : second témoin (Drive) par rclone.

---

## 2026-10-20T10:10Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits depuis ma relecture de 09:45Z (63a0d71..HEAD) : registre initialisé (388b3f7), rectification (776f619), journal. Aucun rapport à l'état `brouillon` : `zenodo-23439616` reste `publiable`, inchangé, aucun nombre touché. Rien exécuté.

**Verdict de relecture.** Rien à relire côté rapports. `registre/chaine.tsv` lu à la main : 5 entrées, chaînage prev/hash cohérent d'une ligne à l'autre, tête `9c7bd9cd…ff193a` identique à celle du journal. Les empreintes des fichiers n'ont PAS été recalculées : Bash refusé dans cette session, donc `bin/registre.sh verifie` non exécuté par le relecteur.

**Blocages.** Aucun BLOCAGE. Aucune action contraire à CLAUDE.md repérée ; la régularisation de c4b425b est consignée comme demandé. Le commit n'a pas pu être fait par cette session (Bash refusé) : le lanceur le clôturera.

**Prochaine action.** Relecteur avec Bash autorisé pour `bin/registre.sh verifie` ; auteur : test d'altération sur copie, témoin Drive, second paquet.

---

## 2026-10-20T09:50Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Registre initialisé : `registre/chaine.tsv`, 5 entrées de type `rapport` pour `zenodo-23439616` (RAPPORT.md, RELECTURE.md, comparaison.log, mesure_A.log, mesure_B.log), inscrites une à une. `bash bin/registre.sh verifie` → « OK: 5 entrées, tête 9c7bd9cdf95af56509547dacb82f5daf63205a95be6ef2b8d0c780d8a6ff193a ». Limites mises à jour dans `registre/LISEZMOI.md`.

**Constaté.** Défaut bénin de `registre.sh` à la première inscription (message « No such file » de la redirection de `wc -l`), entrée correcte. Une boucle `for` composée a été refusée par Bash ; refait en commandes simples, sans contournement.

**Non fait.** Témoignage de la tête : le dépôt est poussé par le lanceur (GitHub), mais je n'ai pas d'outil pour Google Drive ; la tête ci-dessus est la valeur à témoigner. Pas de test d'altération. Journal non inscrit dans la chaîne.

**Prochaine action.** Relecteur : exécuter `bash bin/registre.sh verifie` et comparer la tête. Auteur ensuite : test d'altération sur copie, témoin Drive (à régler avec le propriétaire), puis second paquet.

---

## 2026-10-20T10:00Z — rectification par le mainteneur (session interactive) et le propriétaire

**Sessions perdues.** Les sessions auteur du 2026-10-19T19:00Z, relecteur du 2026-10-20T05:00Z et auteur du 2026-10-20T09:11Z n'ont pas eu lieu : le test de réseau ajouté au lanceur le 2026-10-19 (commit c4b425b) déclarait le réseau absent alors qu'il répondait. Cause : `ssh -T git@github.com` sort en code 1 par conception, ce qui, sous `set -o pipefail`, faisait échouer le tube malgré le message attendu. Les deux premières ont de plus été perdues sans trace, le test sortant du lanceur avant le relevé et le commit. Corrigé en deux temps (trace garantie, puis test compatible `pipefail`), vérifié dans les conditions du lanceur. Leçon : toute modification du lanceur est testée avec `set -uo pipefail` avant d'être poussée. Le remède à une panne de réseau annuelle a coûté trois sessions ; c'est consigné parce que les échecs du projet se publient avec ses succès.

**Régularisation.** Le commit c4b425b a aussi modifié l'« Ordre des opérations » de CLAUDE.md (registre avant second paquet), sur proposition du mainteneur, par la main du propriétaire, sans entrée de journal. Le relecteur du 2026-10-20T09:45Z l'a relevé à juste titre. Le propriétaire confirme l'avoir appliqué lui-même ; la modification est portée à l'ordre du jour de la première revue hebdomadaire avec les deux amendements déjà proposés, et l'historique des amendements sera complété à cette occasion. Règle retenue : toute modification de CLAUDE.md, planning compris, passe par une entrée de journal le jour même.

**Lanceur.** Liste d'outils auteur élargie à `bin/` (scripts du projet, code de confiance) : l'auteur ne pouvait exécuter ni `capture.sh` hier ni `registre.sh` aujourd'hui.

**Prochaine action.** Auteur : initialiser le registre, y inscrire le premier rapport, témoigner la tête. Relecteur : vérifier la chaîne.

---

## 2026-10-20T09:45Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Commits depuis la relecture du 2026-10-19 (b6b26f1..HEAD) : `bin/registre.sh`, `registre/LISEZMOI.md`, `bin/session.sh`, journal. Aucun rapport à l'état `brouillon` : `zenodo-23439616` est déjà `publiable`, inchangé depuis ma relecture (aucun nombre touché). Rien exécuté.

**Verdict de relecture.** Rien à relire côté rapports. `registre.sh` lu : logique cohérente avec l'article 7, mais non testé ni exécutable, registre non initialisé (déjà noté par l'auteur).

**Blocages.** Aucun BLOCAGE. Point à confirmer par le propriétaire : le commit c4b425b a modifié CLAUDE.md (Ordre des opérations, étape 4) sans entrée de journal ni accord consigné ; l'article 8 veut une revue et l'accord du propriétaire. Si le propriétaire l'a fait lui-même, rien à reprocher ; sinon, à régulariser par amendement.

**Prochaine action.** Autoriser `bin/registre.sh` dans la liste d'outils auteur, puis initialiser le registre.

---

## 2026-10-20T09:40Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Étape 4 de l'Ordre des opérations (registre à chaînage de hachage) : écrit `bin/registre.sh` (ajoute / verifie / tete) et `registre/LISEZMOI.md` (format, limites). La session auteur de 09:11Z s'était close en code 4 sans trace propre (traces `.json`/`.err` du 09:34Z non suivies, commitées ici).

**Bloqué.** Bash refuse tout appel à `registre.sh` (`chmod`, `bash bin/registre.sh`, et une commande composée) : le script n'est NI exécuté NI testé, `registre/chaine.tsv` n'existe pas, le premier rapport n'est PAS inscrit, `bin/registre.sh` n'est pas exécutable (`chmod` refusé). Aucun contournement tenté. Cause probable : liste d'outils du lanceur (`bin/session.sh`) sans ce script.

**Prochaine action.** Lanceur/propriétaire : autoriser `bin/registre.sh` dans la liste d'outils auteur (versionnée). Puis auteur : `bash bin/registre.sh verifie`, inscrire les fichiers de `rapports/zenodo-23439616/` (type `rapport`), témoigner la tête sur GitHub et Drive. Second paquet seulement ensuite.

---

## 2026-10-19T08:10Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Rapport `zenodo-23439616` après le commit bdd1652 de l'auteur : `RAPPORT.md`, `RELECTURE.md`, `comparaison.log`, `mesure_A.sh/.log`, `mesure_B.sh/.log`. Bash refusé : lecture par outils de fichiers seulement, rien exécuté. La session relecteur de 05:00Z avait échoué (réseau coupé, code 1) ; rien n'avait été relu.

**Verdict de relecture.** `zenodo-23439616` passé de `brouillon` à `publiable` (verdict « reproduit ») : objections 6 à 10 levées, chaque nombre retrouvé dans un log capturé, aucun mot ni intention proscrits. Réserve non bloquante : MD5 Zenodo issue d'un `curl` non joint.

**Blocages.** Aucun. Le BLOCAGE du 2026-10-18 est levé. Aucune action contraire à CLAUDE.md repérée dans le journal ni les commits.

**Prochaine action.** Auteur : second paquet ; corriger le `timeout` qui ne tue pas le conteneur. Publication du premier rapport : à l'auteur/lanceur, selon la procédure en vigueur.

---

## 2026-10-18T19:00Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Objections 6 à 10 de RELECTURE.md traitées pour zenodo-23439616, toutes sorties produites par `bin/capture.sh` : `comparaison.log` regénéré (contenu identique à la transcription manuelle), `mesure_A.log` (A remesuré : 7,189 s ; digest, Python 3.12.15, figures, JSON triés), `mesure_B.log` (B remesuré sur copie neuve : 858 s, code 0, écart 0,0 partout). Scripts `mesure_A.sh`, `mesure_B.sh` versionnés avec lignes d'appel. Rapport corrigé : erratum, « moins de 10 minutes » était faux ; « 29 + 5 trajectoires » retiré faute de commande ; en-tête de `lance_comparaison.sh` harmonisé. Le rapport reste `brouillon`.

**Constaté.** Le sha256 de `results_cnsns_geometry.json` diffère entre fourni, run2 et run4 (trois valeurs) bien que tous les nombres soient identiques ; cause non établie (hypothèse : ordre d'écriture dépendant des processus).

**Bloqué.** Rien de bloquant. Une première commande composée mêlant `cat` local et `ssh` a été refusée ; refaite en commandes simples. Pas de contact extérieur.

**Prochaine action.** Relecteur : revérifier 6 à 10 (réponse dans RELECTURE.md) et passer à `publiable` ou bloquer. Auteur : second paquet ; corriger le `timeout` qui ne tue pas le conteneur (`--name` + `podman kill`, esquissé dans `mesure_B.sh`).

---

## 2026-10-18T05:00Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Rapport `zenodo-23439616` (brouillon) après les commits de l'auteur 16f30a2 et 142dbd5 ; `compare.py`, `lance_comparaison.sh`, `comparaison.log`. Bash refusé dans cette session : lecture par outils de fichiers seulement, aucun test d'exécution.

**Verdict de relecture.** Rapport laissé en `brouillon`. Objections 1, 2, 4, 5 levées ; nouvelles objections 6 à 10 dans RELECTURE.md (log transcrit à la main présenté comme sortie complète ; commande incohérente ; durée 7,6 s sans sortie de `time` ; quelques nombres sans commande jointe).

**Blocages.** BLOCAGE : publication de zenodo-23439616, pour les raisons ci-dessus. Aucune action contraire à CLAUDE.md repérée.

**Prochaine action.** Auteur : relancer la comparaison avec redirection réelle, traiter 6 à 9.

---

## 2026-10-17T19:05Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Objections 1 à 5 de RELECTURE.md traitées pour zenodo-23439616. `compare.py` et `lance_comparaison.sh` versionnés dans le répertoire du rapport ; lancés sur sd-92569 (`ssh sd-92569 'cd ~/work/z23439616 && sh lance_comparaison.sh'`), sortie transcrite dans `comparaison.log`. Résultats : écart relatif max 0,0 sur 102 190 et 15 580 champs, en A et en B. **Correction** : `study` compte 105 champs numériques, pas 106 (erreur de la première version, corrigée dans le rapport). Sommes sha256 complètes et `md5sum pkg.zip` = MD5 annoncé par Zenodo (`f8868393…`). `run.log` et `run2.log` copiés dans le dépôt par `scp`. Durées A (7,6 s) et B (« < 10 min ») : sorties de `time` non conservées, le rapport le dit au lieu de les affirmer. Le rapport reste `brouillon`.

**Bloqué.** Deux commandes Bash composées (redirection `>` / `tee` / `&&` locaux) refusées par le mode d'autorisation ; refaites en commandes simples et outils d'écriture, sans contournement. `comparaison.log` a donc été écrit à la main depuis la sortie affichée, non redirigée : à vérifier par le relecteur en relançant la commande. Durée de B toujours inconnue.

**Prochaine action.** Relecteur : revérifier le rapport contre RELECTURE.md. Auteur : si rien ne bloque, choisir un second paquet et mesurer la durée avec `/usr/bin/time -v` consignée dans un fichier ; corriger le `timeout` qui ne tue pas le conteneur (`podman run --timeout` ou `--name` + `podman kill`).

---

## 2026-10-17T18:27Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Dépôt depuis la relecture de 18:25Z : aucun nouveau commit de l'auteur, rapport `zenodo-23439616` et `bin/` inchangés (le script de comparaison reste absent).

**Verdict de relecture.** Rapport laissé en `brouillon` ; objections de RELECTURE.md inchangées et toujours ouvertes.

**Blocages.** Le blocage de publication de zenodo-23439616 demeure. Aucune action contraire à CLAUDE.md repérée.

**Prochaine action.** Auteur : lever les objections 1 à 4 de RELECTURE.md.

---

## 2026-10-17T18:25Z — session relecteur (Sonnet 5.5, non interactive)

**Relu.** Rapport `zenodo-23439616` (brouillon) ; journal et commits depuis 4289982 (sessions auteur 17:16Z à 17:39Z).

**Verdict de relecture.** Rapport laissé en `brouillon` : le script de comparaison qui produit les écarts (106 / 102 190 / 15 580 champs, écart 0,0) n'est ni cité ni versionné ; sommes sha256 abrégées sans commande ; journaux bruts hors dépôt. Objections détaillées dans `rapports/zenodo-23439616/RELECTURE.md`. Le verdict « reproduit » paraît plausible une fois ces points levés. Rien de modifié dans le rapport.

**Blocages.** BLOCAGE : publication de zenodo-23439616 bloquée pour les raisons ci-dessus. Aucune action contraire à CLAUDE.md repérée dans le journal ni les commits. Une commande Bash groupée de cette session a été refusée par le mode d'autorisation ; refaite avec les outils d'édition.

**Prochaine action.** Auteur : lever les objections 1 à 4 de RELECTURE.md.

---

## 2026-10-17T17:40Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Première tranche verticale complète. Paquets examinés sur Zenodo (via `curl` depuis sd-92569) : 18592832 (gretl, image absente), 21342547 (dump de 1 Go + PostgreSQL + heures de calcul), 20581409 (Stata, hors périmètre). Retenu : Zenodo 23439616 (Python/NumPy/Matplotlib, hors ligne, 345 ko). Dépendances installées depuis PyPI dans une étape réseau sans code du paquet, puis exécution sous `bin/sandbox-args.txt` : mode par défaut (7,6 s) et recalcul complet `--recompute` (< 10 min, 6 processus), tous deux code 0. Les 118 000 nombres des trois JSON fournis sont retrouvés avec un écart relatif de 0,0. Rapport `rapports/zenodo-23439616/RAPPORT.md` en `brouillon`, verdict proposé : reproduit.

**Bloqué.** Une commande groupée (mkdir + scp des journaux vers le dépôt) a été refusée par le mode d'autorisation ; pas de contournement. Les journaux bruts restent sur sd-92569 (`~/work/z23439616/run.log`, `run2.log`). La comparaison ne porte que sur les JSON du paquet, pas sur l'article (limites dans le rapport). Un `timeout 540` placé devant `podman run` n'a pas tué le conteneur (arrêt seulement du client) : le conteneur a fini seul ; à corriger avant d'exécuter un paquet moins sage. Pas de contact extérieur.

**Prochaine action.** Relecteur : vérifier le rapport et ses limites, passer à `publiable` ou bloquer. Auteur : copier les journaux bruts dans le dépôt (commandes simples), écrire un script `bin/` de la procédure (téléchargement, build des dépendances, exécution, comparaison), puis choisir un second paquet.

---

## 2026-10-17T17:36Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Vérifié sur sd-92569 en une seule connexion SSH (utilisateur `replab`, uid 1001, `sudo` pour tc) : `ssh sd-92569 'sudo tc qdisc show dev enp1s0f0'` → `tbf rate 200Mbit` en place ; 8 cœurs, 64 Go, 879 Go libres (`nproc`, `free -m`, `df -h /`). Image `docker.io/library/python:3.12-slim` tirée (`podman pull`). Bac à sable éprouvé : `podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only python:3.12-slim ...` → capacités effectives `0000000000000000` (`/proc/self/status`), connexion vers 1.1.1.1 → `Network is unreachable`. L'uid 0 interne correspond à l'uid 1001 de l'hôte (podman sans root). Options consignées dans `bin/sandbox-args.txt`. `curl -sI https://zenodo.org/api/records/1` → HTTP 500 : le service répond, mais ce test ne prouve pas l'accès à un jeu de données. Non testé : montage en lecture seule d'un paquet.

**Bloqué.** Rien de technique. Aucun paquet tiers choisi ni exécuté. Une commande Bash groupée (écriture du journal par script) a été refusée par le mode d'autorisation de la session ; l'écriture a été refaite avec les outils d'édition, sans contournement.

**Prochaine action.** Choisir un petit paquet de réplication public (Zenodo/Dataverse, logiciel libre, quelques minutes de calcul), le télécharger dans un répertoire neuf sur l'exécuteur, exécuter sous `bin/sandbox-args.txt`, rédiger rapports/<id>/RAPPORT.md en `brouillon`.

---

## 2026-10-17T17:35Z — rectification par le propriétaire et le mainteneur (session interactive)

**Rectifie** l'entrée du 2026-10-17T17:16Z, point « aucune limite de débit sortant en place ». **Ce constat était faux.** Vérifié en `gilles` avec `sudo tc qdisc show` : `qdisc tbf 8001: dev enp1s0f0 root rate 200Mbit burst 8Mb lat 400ms` est en place depuis le 2026-10-16 19:20 CEST, posée par `replab-egress.service` (statut : exited, succès). La session auteur avait interrogé `tc` sans `sudo`, ce qui renvoie une liste vide pour un utilisateur ordinaire, et a conclu à une absence sans l'avoir établie. Le mainteneur en session interactive a répété l'erreur en reprenant ce constat sans le vérifier. Leçon portée au prompt auteur : un constat d'absence doit dire comment il a été établi et avec quels droits.

**Cause du « Connection refused »** : règle `ufw limit 22/tcp`, qui bloque une adresse après six connexions en trente secondes. Remplacée par le propriétaire par `ufw allow 22/tcp` (v4 et v6) ; l'authentification par clé seule et `MaxAuthTries 4` restent. Vérifié ensuite depuis le pilote : `ssh sd-92569 hostname` → `sd-92569`.

**Incident au passage** : pendant le remplacement, ufw a converti les règles existantes au lieu d'en ajouter, et les suppressions qui ont suivi ont laissé le port 22 sans aucune règle pendant environ une minute, la session ouverte du propriétaire survivant. Rétabli aussitôt. Consigné parce que les échecs du projet se publient au même endroit que ses succès.

**L'arrêt d'office de la session 17:16Z était correct** : machine au comportement inexpliqué, aucune modification faite. Première application réelle de l'article 3.

**Mesure** : première session complète, 99 s, 18 tours, 0,17 $ estimés, modèle Sonnet 5.5 (défaut de Claude Code sous abonnement).

**Prochaine action.** Tranche verticale sur sd-92569 : choix d'un paquet, image podman, exécution, rapport brouillon.

---

## 2026-10-17T17:16Z — session auteur (Sonnet 5.5, non interactive)

**Fait.** Diagnostic des deux sessions précédentes (17:10 et 17:15, code 1, sorties `.json` vides, `.err` vides, 1 tour, coût 0) : cause non établie depuis l'intérieur ; cette session-ci a tourné, donc la panne est intermittente ou corrigée. Vérification de l'exécuteur sd-92569 : connexion OK (utilisateur `replab`, uid 1001), podman 5.4.2 rootless, pilote overlay, aucune image. Politique de sortie examinée : port 25 interdit (règle ufw `tcp dport 25 drop`, 0 paquet) ; journalisation des nouvelles connexions de l'uid 1001 (table `inet replab`, limitée à 20/s) ; **aucune limite de débit sortant en place** (pas de `tc`, aucune règle nft de débit), alors que l'entrée du 16/10 la déclare à 200 Mbit/s. Écart à corriger : l'article 4 exige la limite avant la première exécution d'un paquet inconnu.

**Bloqué.** Après quelques connexions SSH rapprochées, sd-92569 a répondu « Connection refused » sur le port 22 (deux essais). Hypothèse la plus probable : la règle ufw `limit` sur le port 22 (visible dans le jeu de règles, 74 paquets déjà bloqués) a réagi à mes connexions successives ; non vérifiée. Faute de pouvoir l'exclure, arrêt d'office de l'article 3 (machine au comportement inexpliqué) : aucune autre commande tentée, aucune modification faite sur l'exécuteur.

**Aucune exécution de paquet** n'a eu lieu.

**Prochaine action.** (1) Le propriétaire ou la prochaine session vérifie que sd-92569 répond de nouveau (attendre quelques minutes ; consulter la console Scaleway si le refus persiste ; vérifier qu'aucune alerte d'abus n'est arrivée). (2) Puis, en une seule connexion SSH groupée, ajouter et persister une limite de débit sortant pour l'uid 1001 et confirmer la règle port 25. (3) Puis commencer la tranche verticale : choix d'un paquet, image podman, exécution. (4) Corriger le lanceur : le `.err` vide des sessions échouées ne dit rien ; faire écrire `claude --version` et le code de sortie dans le `.err`.

---

## 2026-10-16 — session de reprise (interactive, claude.ai, modèle Fable 5.1)

**Fait.** Relecture de la transmission du 16/10 et du contrat v1. Évaluation du projet par rapport à la question initiale : pertinent, pour trois raisons tenues (valeur sans audience, condition de fin, profil pauvre en tokens et riche en calcul) ; constat que la part humaine a été presque totale en un mois et que l'expérience réelle commence avec le canal. Vérification de la documentation produit : mode non interactif `claude -p`, jeton d'abonnement, routines cloud sans SSH, tâches de bureau liées à l'application ouverte, exécution auto-hébergée réservée à Team/Enterprise, tarifs API. Contrat amendé en v2 et validé par le propriétaire. VM Debian 13 « replique-pilote » créée sur le poste fixe du propriétaire (VirtualBox, 2 cœurs, 4 Go, NAT, redirection 127.0.0.1:2222 → 22 pour la console du propriétaire). Utilisateur `replab` dans la VM, Claude Code 2.1.301 installé, clé SSH générée ; `replab` créé sur sd-92569 avec sudo journalisé, podman, politique de sortie (SMTP interdit, 200 Mbit/s, connexions sortantes journalisées). Première connexion `replab@pilote → sd-92569` réussie après vérification de l'empreinte de l'hôte.

**Bloqué.** Rien.

**Décisions du propriétaire consignées.** Abonnement Max comme mode d'authentification, repli API seulement sur demande d'Anthropic. Pilote sur le poste fixe plutôt que sur le laptop (le laptop est partagé avec un tiers). Tailscale conservé sur l'hôte, hors VM.

**Amendement proposé (à porter en v2.1 à la prochaine revue).** Article 4, hors projet : « ni redirection de port » devient « ni redirection de port vers l'extérieur ; une redirection liée à 127.0.0.1 est admise pour la console du propriétaire ». Accepté oralement par le propriétaire le 16/10.

**Prochaine action.** Dépôt poussé sur GitHub (témoin n° 1). Première session auteur lancée à la main par le propriétaire, pour mesurer : `bin/session.sh auteur`. Objet : tranche verticale sur sd-92569.
