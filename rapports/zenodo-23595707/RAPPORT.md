# Rapport zenodo-23595707 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Les quatre commandes de vérification du README du paquet (`verify_integrity.py --tsr`, `reproduce.py`, `run_conformance_tests.py`, `reproduce_experiments.py`) s'exécutent jusqu'au bout, code de sortie 0, et produisent les décomptes que le README annonce. Ce que « reproduit » couvre est précisé en Limites : le paquet n'a pas relancé les exécutions natives (il les archive), il recalcule les valeurs vérifiées à partir des enregistrements archivés ; le « niveau analytique » (10 contrôles sur 483) n'a pas été exécuté ici ; les nombres de l'article ne sont pas comparés (art. 6 ter).

Couverture : *contrôles internes* (le paquet recalcule ses valeurs à partir des enregistrements archivés et vérifie ses propres résultats conservés ; les exécutions natives ne sont pas relancées).

## Paquet

- Zenodo 23595707, « QSurvDiag replication package », version 1.3.0, publié le 2026-10-23, licence CC-BY-4.0 (mixte, `provenance/LICENSE_MAP.csv` du paquet), un fichier `qsurvdiag-replication-v1.3.0.zip` (10 865 952 octets), données et code inclus, Python bibliothèque standard seulement (README, `readme.log` lignes 14 et 6-8). Fiche : `bin/capture.sh rapports/zenodo-23595707/fichiers.json 'curl -s -m 60 https://zenodo.org/api/records/23595707'` (`fichiers.json`). Découverte : `rapports/zenodo-recherche-20261027/recherche.json` (requête page 2, même méthode que les recherches précédentes) puis `rapports/zenodo-23591167/fichiers.json` (autre candidat consulté, non retenu).
- MD5 annoncée `017477a5…d9bd02cf50ba99` (`fichiers.json`) ; obtenue après téléchargement : identique (`telechargement.log`, ligne 4 ; `extraction.log`, ligne 5 ; `executions.log`, ligne 50). 760 fichiers extraits (`extraction.log`, ligne 6).
- Le README (`readme.log`, lignes 16-28) annonce : `verify_integrity` 0 problème, Freeze A à D RFC 3161 OK, 69 sur 70 conformes pour le gel A et 1 expurgé ; `reproduce` 399 contrôles (MATCH 297, PARTIAL 100, niveau analytique 2) ; `conformance` 3 sur 3 ; `reproduce_experiments` 84 contrôles (MATCH 70, PARTIAL 6, niveau analytique 8).

## Environnement

- sd-92569, podman sans root, image `docker.io/library/python:3.12-slim` (Python 3.12.15, `executions.log` ligne 4), non modifiée. `openssl` présent dans l'image (`executions.log` lignes 6-7), nécessaire à `--tsr`. Options : `--network none --cap-drop all --security-opt no-new-privileges --read-only` ; paquet monté en lecture seule, un seul répertoire `out/` neuf inscriptible. Aucun réseau pendant l'exécution, aucune construction d'image.
- Archive manipulée sur l'hôte uniquement par `python3 -I` (`zipfile.extractall` dans un répertoire neuf, `extrait.sh`) ; aucun code du paquet n'a tourné sur l'hôte.
- La politique de sortie de sd-92569 a été relevée sous `sudo` en début de session : débit limité (`tc qdisc` : `tbf rate 200Mbit`, `rapports/zenodo-recherche-20261027-tc.log` ligne 5), journalisation des nouvelles connexions de l'utilisateur 1001 (table nft `inet replab`, `rapports/zenodo-recherche-20261027-nft.log` lignes 399-404), ports 25, 465 et 587 refusés (même log, lignes 157-159). Cela lève le « constat de procédure » du 26/10.

## Commandes

```
scp rapports/zenodo-23595707/extrait.sh sd-92569:work/z23595707/
bin/capture.sh rapports/zenodo-23595707/extraction.log 'cd ~/work/z23595707 && sh extrait.sh'
scp rapports/zenodo-23595707/lance_executions.sh sd-92569:work/z23595707/
bin/capture.sh rapports/zenodo-23595707/executions.log 'cd ~/work/z23595707 && sh lance_executions.sh'
scp sd-92569:work/z23595707/out/results_verification.csv rapports/zenodo-23595707/results_verification.csv
scp sd-92569:work/z23595707/out/experiments/experiments_verification.csv rapports/zenodo-23595707/experiments_verification.csv
```

Le téléchargement est `telechargement.log` (première ligne : sa commande). Une première tentative de relevé de la politique de sortie, avec `ssh` doublé dans l'appel de `capture.sh`, a échoué (code 255, `rapports/zenodo-recherche-20261027-politique-sortie.log`) ; elle a été refaite en deux commandes (logs `-tc` et `-nft`).

## Résultats

- **1. Intégrité** : sans `--tsr`, 759 fichiers listés, 0 problème, 0 non listé ; 549 identiques à leur source, 4 expurgés (`executions.log` lignes 9-12), code 0. Avec `--tsr` : horodatages RFC 3161 des gels A, B, C et D « Verification: OK » ; manifeste du gel A 69 conformes sur 70, 1 expurgé ; gel B 245 sur 245 ; gel C 3 sur 3 ; gel D 1 sur 1 (lignes 19-26), code 0 (ligne 27). Cela atteste l'accord des fichiers avec les empreintes horodatées par le paquet ; la date des horodatages n'est pas jugée ici.
- **2. `reproduce.py`** : cinq sous-vérifications de code 0 ; **399 contrôles : MATCH 297, PARTIAL 100, NOT REPRODUCED HERE (niveau analytique) 2** ; parmi les valeurs imprimées dans l'article selon le paquet : MATCH 119, PARTIAL 19, non reproduit ici 1 (`executions.log` lignes 29-36), code 0. Les deux contrôles non exécutés (M309, M310) portent la mention « SKIPPED: qutest 0.1.0 not installed » (`results_verification.csv` lignes 286-287). Le tableau complet est `results_verification.csv`.
- **3. Conformité** : `test_minimal_conformance.py` 41/41, `test_conformance_789.py` 41/41, `test_decision_bound.py` 22/22 (lignes 41-43), code 0.
- **4. `reproduce_experiments.py`** : **84 contrôles : MATCH 70, PARTIAL 6, NOT RUN (niveau analytique) 8** (ligne 46), code 0 ; tableau complet : `experiments_verification.csv`.
- Ces décomptes sont ceux que le README annonce (hors niveau analytique). Aucun contrôle en échec, aucun code non nul.

## Limites

- **Ce que « MATCH » et « PARTIAL » mesurent** (définitions du README, `readme.log` lignes 30-32) : MATCH, recalculé à partir d'enregistrements par cas ou par exécution ; PARTIAL, égal à un agrégat archivé, à un enregistrement de protocole ou à l'historique git enregistré. Le README dit que les exécutions natives de QUTest et QuCheck sont archivées et non relancées : la portée *paquet* ici signifie « les valeurs vérifiées sont retrouvées par le code du paquet à partir de ses enregistrements », non « les mutants ont été relancés ». Cette lecture de la portée *paquet* est celle que la revue n° 3 doit trancher (`journal/AMENDEMENTS.md`, point « portée et régénération »).
- **Niveau analytique non exécuté** : 2 contrôles de `reproduce.py` et 8 de `reproduce_experiments.py` exigent QUTest 0.1.0 (git depuis GitHub, commit nommé), un environnement Python 3.12 avec dépendances par pip et un fichier de référence QED-C tiré d'un autre dépôt GitHub (`readme.log` lignes 34-52). Rien de cela n'a été téléchargé ni lancé. Le verdict ne dit rien de ces 10 contrôles.
- Aucune comparaison avec l'article (non lu) ; `expected/` du paquet liste, selon le README, les valeurs attendues et indique si l'article les imprime ; je n'ai pas vérifié ce renvoi.
- Les fichiers `out/` produits (3,9 Mo, `sortie_liste.log`) restent sur sd-92569 ; seuls les deux tableaux de contrôles ont été copiés dans ce répertoire.
- Aucun auteur n'est notifié : le verdict n'est pas *divergent* (art. 6).
