# Rapport zenodo-23511350 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet** (la commande d'entrée du paquet, `python3 run_verification_suite.py`, s'exécute jusqu'au bout et ses 97 + 72 contrôles passent, une fois NumPy ajouté comme le guide l'exige ; les nombres de l'article ne sont pas comparés, art. 6 ter). Ce que « reproduit » couvre exactement est précisé en Limites : il s'agit de la cohérence des résultats bruts conservés avec les valeurs rapportées, pas d'une régénération des mesures.

Couverture : *contrôles internes* (le paquet vérifie la cohérence de ses résultats bruts conservés avec les valeurs rapportées, sans régénérer les mesures).

## Paquet

- Zenodo 23511350, « Decision-Free Algebraic Rejection for Post-Quantum Key Encapsulation: Replication Package », version V1.0.0, publié le 2026-10-25, licence CC-BY-4.0, un fichier `DFAR_Replication_Package_Final_Zenodo.zip` (407 114 octets), données et code inclus. Fiche : `bin/capture.sh rapports/zenodo-23511350/fiche_zenodo.json "curl -s -m 30 'https://zenodo.org/api/records/23511350'"` (`fiche_zenodo.json`). Découverte : `rapports/zenodo-recherche-20261026/recherche.json` (requête et fichier de liste `f23511350.json` dans ce répertoire).
- Somme MD5 annoncée `bcbdf663…0c0` (`rapports/zenodo-recherche-20261026/f23511350.json`) ; obtenue après téléchargement : identique (`telechargement.log`, ligne 4 ; `extraction.log`, ligne 5). Contenu : 139 entrées dans l'archive (`contenu.log`, lignes 4-142) et 139 fichiers extraits (`extraction.log`, ligne 6) ; le script de manifeste du paquet en compte 138 (`executions_numpy.log`, ligne 24), écart non examiné (le manifeste ne se liste vraisemblablement pas lui-même — hypothèse, aucune commande ne l'a vérifié).
- Le paquet affirme (`REPLICATION_GUIDE.txt`, copie : `guide.log`, lignes 58-64) que `python3 run_verification_suite.py`, lancé depuis la racine du paquet, vérifie les résultats principaux x86, les campagnes secondaires, les mutations, le diagnostic de 300 000 sorties, les statistiques de temps, les enregistrements Go et ARM64 et des contrôles structurels. Il dit aussi (`guide.log`, lignes 134-143) que NumPy est requis pour la régénération exacte des intervalles BCa.

## Environnement

- sd-92569, podman sans root. Image de base `docker.io/library/python:3.12-slim` (Python 3.12.15, `executions.log`, ligne 20), **sans NumPy** (`executions.log`, lignes 15-18). Image dérivée `replab-dfar-numpy` (`Containerfile` : une seule ligne, `pip install --only-binary=:all: numpy`, NumPy 2.5.4 — `executions_numpy.log`, lignes 4-22). Seul accès réseau : PyPI, pendant la construction. Les exécutions du paquet : `--network none --cap-drop all --security-opt no-new-privileges --read-only`, paquet monté en lecture seule. La liste des images est dans `executions_numpy.log`, lignes 378-380.
- Archive manipulée sur l'hôte uniquement par `python3 -I` (listage et `zipfile.extractall` dans un répertoire neuf, `extrait.sh`) ; aucun code du paquet n'a tourné sur l'hôte.
- Le téléchargement (`telechargement.log`) contient une première commande `curl -O` redondante qui a écrit un fichier inutilisé dans `~/work/z23511350/zip/` ; elle n'a pas servi (la somme porte sur `DFAR.zip`, obtenu par la seconde). Cette commande maladroite est conservée telle quelle au log.

## Commandes

```
scp rapports/zenodo-23511350/extrait.sh sd-92569:work/z23511350/
bin/capture.sh rapports/zenodo-23511350/extraction.log 'cd ~/work/z23511350 && sh extrait.sh'
scp rapports/zenodo-23511350/lance_executions.sh sd-92569:work/z23511350/
bin/capture.sh rapports/zenodo-23511350/executions.log 'cd ~/work/z23511350 && sh lance_executions.sh'
scp rapports/zenodo-23511350/lance_numpy.sh rapports/zenodo-23511350/Containerfile sd-92569:work/z23511350/
bin/capture.sh rapports/zenodo-23511350/executions_numpy.log 'cd ~/work/z23511350 && sh lance_numpy.sh'
```

(`contenu.log` : `bin/capture.sh rapports/zenodo-23511350/contenu.log "python3 -I -c \"import zipfile;[print(i.file_size,i.filename) for i in zipfile.ZipFile('/home/replab/work/z23511350/DFAR.zip').infolist()]\""`.)

## Résultats

- **A. Image Python sans NumPy** : `python3 run_verification_suite.py` s'arrête à la troisième étape, `analysis/recompute_p1_native_x86_summary.py`, code de sortie **1**, message `FAIL: NumPy is required for exact P1 BCa regeneration` (`executions.log`, lignes 7 et 14). Les deux premières étapes passent (`PACKAGE_MANIFEST_VERIFICATION_PASS files=138`, `P1_RESULT_VERIFICATION_PASS`, lignes 5-6). Ce n'est pas un défaut du paquet : sa dépendance est déclarée dans son guide. C'est une propriété de l'environnement minimal : le paquet ne fournit ni `requirements.txt` ni version de NumPy (aucune commande n'a cherché un tel fichier hors de la liste `contenu.log`, où il n'apparaît pas).
- **C. Image avec NumPy 2.5.4** : même commande, code de sortie **0**, dernière ligne `DFAR_FULL_VERIFICATION_PASS` (`executions_numpy.log`, lignes 376-377). Détail : manifeste 138 fichiers (ligne 24) ; régénération BCa avec graine 20260922 et 10 000 rééchantillonnages, trois médianes appariées −2,783843603541 (ML-KEM-512), −1,423039527423 (768), −1,263996896824 (1024) (lignes 26-29) ; `TOTAL=97 PASS=97 FAIL=0` (ligne 140) ; `ARM64_TOTAL=72 PASS=72 FAIL=0` (ligne 214) ; contrôles structurels `graphs_tested=1099 … =PASS` (ligne 215) et campagne de mutation sur 10 000 essais par paramètre (lignes 221-358).
- Même archive dans les deux cas : `md5sum DFAR.zip` identique (`executions.log`, ligne 22).

## Limites

- **Ce que le « PASS » mesure.** Les scripts `verify_*` recomptent des statistiques à partir des fichiers bruts conservés dans le paquet (CSV, journaux) et les comparent à des valeurs écrites dans les scripts. Rien dans la commande d'entrée ne recompile le C, ne relance la campagne de 20 × 5 000 décapsulations, la campagne ARM64 (matériel AArch64 requis, `guide.log` ligne 103) ni les tests Go : les lignes `PASS: Go …` (`executions_numpy.log`, lignes 120-138) relisent des journaux conservés. Les mesures de temps ne sont donc pas régénérées. Les chemins de reconstruction décrits au guide (`run_clean_replay.sh`, `build_p1.sh`, OpenSSL 3.5.5 statique, GCC) n'ont pas été exécutés ici.
- Le verdict porte sur le paquet : ses résultats fournis sont cohérents avec ceux qu'il rapporte. Aucune comparaison avec le manuscrit (non lu), aucune évaluation de la sécurité ou de la preuve.
- L'unique différence avec l'environnement de départ est l'ajout de NumPy 2.5.4 (version la plus récente disponible le 26/10 ; le paquet n'en nomme aucune) ; la régénération BCa a donné les valeurs attendues avec cette version.
- Aucun auteur n'est notifié : le verdict n'est pas *divergent* (art. 6).
