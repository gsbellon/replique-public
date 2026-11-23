# Rapport zenodo-24353093 — état : publiable

Verdict : **inexécutable** — portée : **paquet**. La commande documentée par le README pour régénérer les analyses (`python run_wchn.py`, README, « To reproduce the updated reduced and size-adjusted statistics ») échoue sur le paquet tel que livré, au bout de la ligne 25 du script : `ModuleNotFoundError: No module named 'artifact_tool'`, code 1 (`run.log`, section A). Le module `artifact_tool`, que le README et l'en-tête du script exigent, n'a aucune distribution sur PyPI : `pip download artifact_tool` répond « No matching distribution found » (`pip_artifact_tool.log`, code 1) ; le paquet ne le fournit pas (la liste de la fiche, `fiche_zenodo.json`, n'a aucun fichier de ce nom ; le ZIP d'outils de reconstruction n'a pas été ouvert). La portée *paquet* ne dit rien des nombres de l'article lié : la fiche le lie (`isSupplementTo`, DOI `10.1016/j.ecolmodel.2023.110345`, Ecological Modelling), mais le README déclare que le dépôt est « independent of any particular journal or manuscript » et que ses analyses sont de nouveaux calculs, et ce rapport n'a pas lu l'article.

Couverture : *exécution seule* sur le paquet tel que livré (aucune sortie produite, rien n'a pu être comparé). La section « Hors paquet » ajoute une *régénération* limitée au fichier JSON de résultats ; les classeurs `.xlsx` ne sont pas régénérés.

## Paquet

- Zenodo 24353093, « Recalculated woody crown hydraulic network properties and reduced principal component analyses of Caatinga and Cerrado trees », version 2.2.0, un créateur (Universidade Federal de São Carlos), CC BY 4.0, publié le 2026-11-18 (`fiche_zenodo.json`, obtenue par `curl` de `https://zenodo.org/api/records/24353093`). 27 fichiers (`grep -o '"key": ' fiche_zenodo.json`), dont le README, `run_wchn.py`, deux CSV d'entrée et le JSON de résultats ; l'archive d'outils de reconstruction (`WCHN_toolkit_v1.0.3_deposit.zip`, 8,8 Mo) n'est pas utilisée par `run_wchn.py` (README : « separate from the network-reconstruction toolkit »).
- Trouvé par la requête Zenodo `req4_recherche.json` (relation `isSupplementTo` vers un DOI de revue, accès ouvert) après trois requêtes de collections de revues (`req1_ej.json`, `req2_restud.json`, `req3_ectj.json`) dont aucun résultat ne porte d'identifiant de revue dans sa fiche (`grep -c related_identifiers` : aucune occurrence dans ces trois fichiers).
- Fichiers téléchargés sur l'hôte par `curl` seulement, 13 MD5 de la fiche concordants (`telechargement.log`, `telecharge.sh`). Aucun code du paquet n'a tourné sur l'hôte.
- Le README demande « numpy, scipy, matplotlib, artifact_tool » sans versions ; il ne donne ni version de Python ni tolérance.

## Environnement

- sd-92569, podman sans root. Image `replab-wchn` (`Containerfile`, `lance_build.sh`, `build.log`) : base `python:3.11-slim` désignée par l'empreinte `sha256:b701198cb708b68d9413ca67d6311bd97c9389a2c5fe4da0511fc652642366cd` ; `numpy==2.1.1`, `scipy==1.13.1`, `matplotlib==3.9.2` (versions choisies par le projet, le paquet n'en fixe aucune ; relevées dans `build.log` : Python 3.11.18). Image archivée `~/images/zenodo-24353093.tar`, sha256 `25f0a8150b4cf921b73e9da6e4b8b0f6c1e9175d873f588a8025eeb9529fa169`, identifiant `f083a767a343fcb7e502b22d59f39c94e0254b7a176b2ddde16dc15d3da54259` (`build.log`).
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture (`runA`, `runB`), original intact dans `pkg/` (`lance_run.sh`).

## Critère

Écrit avant exécution et comparaison : `CRITERE.md` (2026-11-23). JSON : `bin/compare_json.py --rtol 1e-6 --atol 1e-9`, rien d'ignoré ; images hors verdict (octet par octet à titre d'information) ; classeurs hors de portée.

## Résultats

1. **Paquet tel que livré** : `python run_wchn.py` → `ModuleNotFoundError`, code 1 (`run.log`, A ; commande `bin/capture.sh … 'cd ~/work/z24353093 && sh lance_run.sh'`).
2. Aucune sortie n'est produite à cette étape ; ni valeur ni fichier n'est comparé pour le paquet tel que livré.

## Hors paquet

Correction minimale et nommée : fournir un module `artifact_tool` de remplacement, écrit par Réplique (`shim/artifact_tool.py`, 29 lignes), qui accepte les appels de classeur du script et n'écrit aucun `.xlsx`, placé sur `PYTHONPATH` (`-e PYTHONPATH=/shim`). Aucune autre modification du script ni des entrées. Avec lui, `python run_wchn.py` s'exécute en code 0 en moins de 4 s, affiche « SUCCESS: regenerated 2 workbooks, 6 images, JSON » (ce message est inexact pour les classeurs : le remplacement ne les écrit pas, `run.log`, B).

- **JSON** : `WCHN_partial_correlations_results.json` régénéré contre le fichier livré, `compare.sh` → `bin/compare_json.py --rtol 1e-6 --atol 1e-9` : « RESULTAT: identique » (`compare.log`, ligne 5). En égalité exacte 185 valeurs diffèrent, aucune au-delà de 1e-10 en valeur relative (`compare_seuils.log` : identique à rtol 1e-10, 1 écart à 1e-12, 14 à 1e-13, 42 à 1e-14, 108 à 1e-15) ; octet par octet le fichier diffère (`cmp`, octet 368).
- **Valeurs imprimées** (`run.log`, B) : PC1+PC2 réduit 91,05163 % (Caatinga) et 89,83056 % (Cerrado) ; ajusté 98,92912 % et 97,47483 % ; NAV–VUL −0,9734 et −0,9501 ; BAS–VUL −0,9598 et −0,8454. Ces valeurs sont celles que le README rapporte arrondies (91,1 %, 89,8 %, 98,9 %, 97,5 %, ≈ −0,97/−0,95, ≈ −0,96/−0,85, README ligne 57–59) ; leur égalité aux valeurs du JSON est établie par la comparaison JSON ci-dessus, non par les arrondis.
- **Images** (hors verdict) : les 4 PNG et 2 SVG régénérés diffèrent des livrés à l'octet (`compare.log`, `cmp`, hachages donnés) ; la version de matplotlib des auteurs est inconnue, la cause n'est pas examinée.
- **Non régénérés** : `Reduced_PCA_WCHN_Caatinga_Cerrado.xlsx` et `WCHN_correlacoes_parciais_PCAs_ajustadas.xlsx` (module de remplacement sans écriture) ; les tableaux `.docx`, le fichier de corrections et l'archive d'outils ne sont produits par aucun script de ce dépôt.

Ce que la correction prouve : avec un module de classeur muet, les nombres du JSON livré se retrouvent au critère. Ce qu'elle ne prouve pas : le contenu des classeurs, des tableaux, des figures, ni les nombres de l'article.

## Limites

- Les versions de numpy, scipy et matplotlib sont celles du projet ; celles des auteurs ne sont pas données.
- `artifact_tool` pourrait exister dans l'environnement des auteurs sous une autre forme ; ce rapport dit seulement qu'il n'est ni dans le paquet ni sur PyPI au 2026-11-23 (`pip_artifact_tool.log`, depuis l'image de base, avec accès réseau).
- Rien n'est dit de la validité des analyses statistiques.

## Commandes

Toutes depuis la racine du dépôt, via `bin/capture.sh <journal> '<commande sur sd-92569>'` ; scripts versionnés dans ce dossier :

- `telecharge_lecture.sh` → `telechargement_lecture.log`, `readme.log`, `run_wchn.py.log` (lecture)
- `telecharge.sh` → `telechargement.log`
- `lance_build.sh` + `Containerfile` → `build.log`
- `lance_run.sh` + `shim/artifact_tool.py` → `run.log`
- `compare.sh` → `compare.log` ; seuils : `compare_seuils.log` (boucle `for r in 1e-10 1e-12 1e-13 1e-14 1e-15` sur `compare_json.py --rtol $r --atol 0`, ligne d'appel dans l'en-tête du journal)
- `pip download artifact_tool` → `pip_artifact_tool.log`
