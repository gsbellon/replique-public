# Rapport zenodo-23607297 — état : publiable

Verdict : **inexécutable** — portée : **paquet** (le script livré, lancé comme le README l'indique, ne s'exécute pas ; les nombres de l'article ne sont pas comparés, art. 6 ter). *Inexécutable* est un fait sur le paquet, pas sur la science.

## Paquet

- Zenodo 23607297, « Per-model language z-scores on LTBv1 (Chinese-source subset): replication package », dépôt déclaré sous nom de créateur anonyme (`creators` : « Anonymous »), données incluses (4 fichiers : `README.md`, `ltb_per_model_zscores.csv`, `recompute_from_release.py`, `ATTRIBUTION.md`). Titre, créateur et liste des fichiers : fiche Zenodo, `bin/capture.sh rapports/zenodo-23607297/fiche_zenodo.json "curl -s -m 30 'https://zenodo.org/api/records/23607297'"` (`fiche_zenodo.json`).
- Liste des fichiers et sommes MD5 annoncées : `bin/capture.sh rapports/zenodo-23607297/fichiers.json "curl -s -m 30 'https://zenodo.org/api/records/23607297/files'"`. Téléchargement des quatre fichiers sur sd-92569 (`curl` sans exécuter de code du paquet) et `md5sum` : `telechargement.log`. Les quatre sommes obtenues (`9d488016…`, `f8136fae…`, `ac0aae26…`, `d5b73c3d…`) sont celles annoncées par Zenodo (comparées dans `executions.log`, section `== md5`, et dans `fichiers.json`).
- Le paquet affirme (README, texte intégral : `bin/capture.sh rapports/zenodo-23607297/readme.log 'cat ~/work/z23607297/pkg/README.md'`, `readme.log`, lignes 20-33) : « Reads only this CSV; no network access, no external dependencies » (« this CSV » désignant `ltb_per_model_zscores.csv`) et la commande `python recompute_from_release.py` avec une sortie attendue se terminant par `ALL PASS`.

## Environnement

- sd-92569, podman sans root, image `docker.io/library/python:3.12-slim` (déjà présente ; `bin/capture.sh rapports/zenodo-23607297/podman_images.log 'podman images'`, `podman_images.log`, exécutée le 25/10, après les exécutions du 24/10 : elle établit la présence de l'image, pas son état au moment des exécutions). Options : `--network none --cap-drop all --security-opt no-new-privileges --read-only`, paquet monté en lecture seule (`bin/sandbox-args.txt`). Aucune dépendance (bibliothèque standard).

## Commandes

Tout est produit par un seul script versionné, `lance_executions.sh` :

```
scp rapports/zenodo-23607297/lance_executions.sh sd-92569:work/z23607297/
bin/capture.sh rapports/zenodo-23607297/executions.log 'cd ~/work/z23607297 && sh lance_executions.sh'
```

## Résultats

- **A. Script tel que livré** (`python -I recompute_from_release.py`, répertoire = paquet) : code de sortie **1**, `FileNotFoundError` sur `'D:/我的论文项目/平台化AI翻译文化折扣_2026/04_语料与数据/ltb_tableA1_extracted_20261023.csv'` (`executions.log`, section A). La ligne 8 du script (`grep -n "^CSV"`, même log) fixe ce chemin Windows absolu ; le CSV du paquet a un autre nom (`ltb_per_model_zscores.csv`). Le README dit pourtant que le script lit ce CSV (`readme.log`, ligne 21).
- **B. Mesure complémentaire, hors paquet** : copie `patch/recompute_patched.py` où seule la ligne 8 est remplacée par `CSV = r'/pkg/ltb_per_model_zscores.csv'` (`diff` dans `executions.log`, section B). Code de sortie 0, `ALL PASS` : CN-developed n=7, moyenne 1,3841, médiane 1,1851, 7/7 positifs ; Non-CN n=24, moyenne 0,0089, médiane −0,1221, 9/24 positifs ; U = 156,0 ; p exact bilatéral = 1,8710e-04 (2 629 575 combinaisons = C(31,7)). Ces valeurs sont celles du README.

## Limites

- Le verdict porte sur le paquet tel que livré. B montre qu'une correction d'une ligne suffit à obtenir la sortie annoncée ; ce n'est pas une exécution du paquet et ne change pas le verdict A. Le relecteur peut juger que ce cas relève d'un autre verdict ; je propose *inexécutable* parce que la commande documentée échoue.
- On ne sait pas si `ltb_tableA1_extracted_20261023.csv` (nom attendu par le script) a le même contenu que `ltb_per_model_zscores.csv` : aucune commande ne l'a établi.
- Le « ALL PASS » du script compare le résultat à des valeurs écrites dans le script lui-même, pas à l'article, que je n'ai pas lu ; le paquet ne redistribue pas LTBv1 (`readme.log`, ligne 41), donc les z-scores ne sont pas recalculés depuis les données de base.
- Aucun auteur n'est notifié : le verdict n'est pas *divergent* (art. 6).
