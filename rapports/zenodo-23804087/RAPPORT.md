# Rapport zenodo-23804087 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. La commande du « Quick start » du README (`python3 tools/run_evaluation.py`) s'exécute jusqu'au bout, code 0, et ses cinq études obligatoires affichent PASS ; les deux études optionnelles (SUMO, Mesa) sont SKIPPED, faute de ces logiciels dans l'image (`run.log`). Les tests unitaires du paquet (42) passent. Sur les 16 fichiers de `results/`, 13 sont identiques à l'octet à ceux livrés ; 3 diffèrent, uniquement par des champs d'environnement, des mesures de temps et des fins de ligne (Résultats, points 2 à 4). La portée *paquet* ne dit rien des nombres de l'article, qui n'a pas été lu (art. 6 ter) ; les études 6 et 7 (SUMO, Mesa) ne sont pas couvertes.

Couverture : *régénération* (les 16 fichiers de `results/` sont régénérés et comparés ; les études 6 et 7 ne sont pas couvertes).

## Paquet

- Zenodo 23804087, « Replication package for "Cross-domain Specification of Switching Policies in Multi-level Simulation" », publié le 2026-10-30, neuf auteurs (FZI, KIT, Mannheim, Volvo CE, AVL List, Ulm), type logiciel, accès ouvert, licence CC-BY-4.0. Fiche : `bin/capture.sh rapports/zenodo-23804087/fiche_zenodo.json 'curl -sS -f -m 60 https://zenodo.org/api/records/23804087'`.
- Un fichier, `replication-package_JSS.zip`, 131 971 octets (fiche) ; MD5 de la fiche concordant avec le fichier téléchargé (`telechargement.log`, ligne « OK ») ; 81 fichiers extraits (même fichier, sortie de `find . -type f | wc -l`), code d'extraction 0.
- Données : aucune donnée externe ; le paquet est autonome (README : Python ≥ 3.9, bibliothèque standard seulement). Art. 1 : dans le périmètre.
- Le README annonce l'exécution de sept études ; il décrit les attendus de chacune et dit que la commande « exits non-zero if any documented expectation is not met ».

## Environnement

- sd-92569, podman sans root, image `docker.io/library/python:3.12-slim` déjà présente (`run.log`, sortie de `podman images`), Python 3.12.15 (`run.log`). Aucune construction d'image : le paquet n'a aucune dépendance. Les auteurs ont testé SUMO 1.27.1 et Mesa 3.3.1 sur Python 3.13 (fiche) ; ils ne donnent pas la version de Python de la production de `results/` hors ce que les fichiers livrés enregistrent (3.11.2 sous Windows 10 pour `scenario_metrics.json`, 3.10.12 sous Linux pour `randomized_metrics.json`).
- Archive manipulée sur l'hôte uniquement par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) ; aucun code du paquet n'a tourné sur l'hôte.
- Politique de sortie de l'hôte vérifiée avant l'exécution : ports 25, 465, 587 refusés (IPv4 et IPv6), destinations journalisées pour l'utilisateur 1001, à 20 nouvelles connexions par seconde (`politique_sortie.log`, `sudo nft list ruleset`).
- Exécution : conteneur `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seul `run/` monté en écriture (copie du paquet ; l'original reste intact dans `pkg/`) (`lance_run.sh`, `run.log`). Aucun réseau pendant l'exécution, aucun secret à bord.

## Résultats

1. **Exécution.** `run_evaluation.py` : code 0. Études 1 à 5 : PASS. Études 6 et 7 : SKIPPED (optionnelles, SUMO et Mesa absents ; le README dit qu'elles sont ignorées sans faire échouer la suite). `python3 -m unittest discover -s tools -p "test_*.py"` : 42 tests, OK, code 0. Durée de l'ensemble : 15 s (`run.log`, 20:00:48Z à 20:01:03Z ; `capture.sh` : 15 s).
2. **Comparaison de `results/`.** `diff -rq pkg/results run/results` (`comparaison.log`) : 16 fichiers de chaque côté ; trois diffèrent : `randomized_metrics.json`, `scenario.md`, `scenario_metrics.json`. Les 13 autres sont identiques à l'octet, dont `validation.md`, `analysis.md`, `comparative.md`, `comparative_sensitivity.md`, `traffic.md`, `randomized.md`, `traffic_metrics.json` et les fichiers `.tex`. Le reste du paquet (hors `results/`) est inchangé par l'exécution (`diff -rq pkg run`, même fichier).
3. **`randomized_metrics.json`.** Seul le bloc `environment` diffère : version de Python (3.10.12 livré, 3.12.15 régénéré) et plateforme (`comparaison.log`, `diff -u`). Les résultats de l'étude 5 (500 ensembles, vérité de terrain STABLE=211 SLOW=171 FAST=118, E1 0, E2 0, hérités 13/21, conservatisme 100 : `run.log`) sont identiques à ceux livrés, le fichier ne différant pas ailleurs.
4. **`scenario_metrics.json` et `scenario.md`.** Les différences sont : (a) l'environnement (Python, CPU, système) ; (b) la mesure de surcoût d'évaluation des politiques, qui est une mesure de temps de la machine d'exécution : médiane 8,15 µs livrée contre 5,51 µs régénérée, soit 0,815 % contre 0,551 % d'un pas de 1 ms ; (c) les fins de ligne : `scenario.md` livré contient 39 lignes en CRLF, le régénéré 0 (`crlf.log`, `grep -c -P "\r$"`) ; (d) l'absence de retour à la ligne final de `scenario_metrics.json` régénéré. Avec `diff --strip-trailing-cr pkg/results/scenario.md run/results/scenario.md` (`diff_sans_cr.log`), la seule ligne qui diffère est la ligne 17, la phrase du surcoût (8,2 µs → 5,5 µs, échantillons, 0,82 % → 0,55 %). Les nombres déterministes (calcul 240 / 1920 / 838, erreur 84 / 0 / 10, commutations 2, économie 56,4 %, réduction d'erreur 88,1 %, sensibilité, oscillation 38 / 12 / 0) sont identiques.
5. Le README annonce que le surcoût est une médiane de répétitions « measurement environment recorded in `results/scenario_metrics.json` » : c'est un nombre dépendant de la machine, qui ne peut pas être attendu identique ; il reste sous 1 % d'un pas de 1 ms dans les deux cas.

## Limites

- Portée *paquet* : les sorties livrées sont régénérées par le code livré. Rien n'est dit des nombres de l'article, qui n'a pas été lu. Les auteurs écrivent que `run_evaluation.py` « reproduces the tool-supported part of the paper's evaluation » ; je n'ai pas vérifié cette correspondance avec le texte de l'article.
- Les études 6 (SUMO) et 7 (Mesa) n'ont pas été exécutées : elles exigent `pip install eclipse-sumo traci sumolib mesa`, donc un accès réseau à PyPI ; elles sont hors de ce rapport. Les résultats livrés correspondants (`results/sumo*.md`, `results/mesa*.md`, `results/*_metrics.json`) sont identiques à l'octet après l'exécution (`diff -rq`, `comparaison.log`), mais comme les études 6 et 7 n'ont pas tourné, cette identité ne prouve pas qu'elles seraient régénérées : leur contenu n'est ni confirmé ni infirmé ici.
- Les 5 études obligatoires sont déterministes sauf la mesure de temps de l'étude 4 ; la répétabilité sur une seconde exécution n'a pas été mesurée.
- La méthode 1 de l'évaluation (expressivité/couverture) est, selon le README, analytique ; seul son tableau de codage (`coding/coverage.csv`) est dans le paquet, et `comparative.py` en dérive les verdicts. Le rapport ne dit rien du bien-fondé du codage.

## Commandes

```
bin/capture.sh rapports/zenodo-23804087/fiche_zenodo.json 'curl -sS -f -m 60 https://zenodo.org/api/records/23804087'
scp rapports/zenodo-23804087/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23804087/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23804087/readme.log 'cat work/z23804087/pkg/README.md'
scp rapports/zenodo-23804087/lance_run.sh sd-92569:work/z23804087/
bin/capture.sh rapports/zenodo-23804087/run.log 'cd ~/work/z23804087 && sh lance_run.sh'
scp rapports/zenodo-23804087/compare.sh sd-92569:work/z23804087/
bin/capture.sh rapports/zenodo-23804087/comparaison.log 'cd ~/work/z23804087 && sh compare.sh'
bin/capture.sh rapports/zenodo-23804087/crlf.log 'cd ~/work/z23804087 && grep -c -P "\r$" pkg/results/scenario.md run/results/scenario.md pkg/results/scenario_metrics.json run/results/scenario_metrics.json'
bin/capture.sh rapports/zenodo-23804087/diff_sans_cr.log 'cd ~/work/z23804087 && diff --strip-trailing-cr pkg/results/scenario.md run/results/scenario.md'
bin/capture.sh rapports/zenodo-23804087/politique_sortie.log 'sudo nft list ruleset'
```

Chaque nombre ci-dessus provient du fichier nommé à côté de lui. Les fichiers `.log` ont tous été produits par `bin/capture.sh`.
