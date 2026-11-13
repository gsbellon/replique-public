# Rapport zenodo-24141273 — état : publiable

Verdict proposé : **inexécutable** — portée : **paquet**. Sur le paquet tel que livré, la commande documentée par le README (`python run_all.py`), exécutée dans un conteneur sans réseau avec les versions exactes de `requirements.txt` (dont `numpy==2.5.3`), s'arrête à l'étape `20_baseline.py` avec le code 1 : `TypeError: only 0-dimensional arrays can be converted to Python scalars`, levée dans `pydynpd/specification_tests.py` (`run1_telle_que_livree.out`). Une correction minimale et nommée (section « Hors paquet ») — remplacer `numpy==2.5.3` par `numpy==2.3.5`, sans toucher au code du paquet — permet à `run_all.py` d'aller au bout (code 0, 2 849 s) ; 84 des 88 fichiers CSV de sortie sont alors identiques aux fichiers livrés, à l'égalité exacte ; 4 diffèrent (détail ci-dessous). Ces constats hors paquet ne changent pas le verdict, qui porte sur le paquet tel que livré.

Couverture : *régénération* (les sorties livrées dans `output/` sont régénérées par la correction hors paquet et comparées ; sur le paquet tel que livré, aucune sortie n'est régénérée au-delà de l'étape 01).

## Paquet

- Zenodo 24141273, « Replication package for: Fiscal Capacity in the Digital Age: What Survives Identification? Evidence from 145 Countries », publié le 2026-11-11, cinq auteurs, type logiciel, accès ouvert, CC BY 4.0. Fiche : `zenodo_notice.json` (`bin/capture.sh rapports/zenodo-24141273/zenodo_notice.json 'curl -s -m 60 https://zenodo.org/api/records/24141273'`).
- Un fichier, `replication_package_v1.0.1.zip`, 10 057 611 octets ; MD5 de la fiche concordant (`telechargement.log`, « OK ») ; 273 fichiers extraits, code d'extraction 0. Script : `telecharge_extrait.sh`.
- Documentation : `README.md`, `requirements.txt`, `run_all.py` lus par `readme.log`. Le README annonce Python 3.11 ou plus (« tested with Python 3.13 »), « about 55 minutes on a 2-core cloud machine », et que « all estimates are bit-for-bit reproducible » ; seuls les temps de calcul du tableau C2 changent d'une exécution à l'autre.
- Le paquet livre ses sorties dans `output/` (88 CSV, 29 figures PNG, 31 JSON de résultats, `run_all.log`) : c'est la référence de la comparaison.

## Environnement

- sd-92569, podman sans root. Image `replab-fiscal` (`Containerfile`, `lance_build.sh`, `build.log`) : base `python:3.13-slim` désignée par l'empreinte `sha256:48d884813cf44e927cf64c5529dd630dd3b18338c6dc727991eef9b71e934a20` (relevée par `base_image.log`), Python 3.13.18 ; dépendances aux versions exactes de `requirements.txt` ; `openpyxl` (résolu : 3.1.5) et `xlrd` (2.0.2) ne sont pas épinglés par le paquet ; `geonamescache` (utilisé par `00b_coordinates.py` seul, non lancé par `run_all.py`) n'est pas installé. Versions résolues : `pip freeze` dans `build.log`. Image archivée : `~/images/zenodo-24141273.tar`, sha256 `f89bbcec28811019c429813e82ae3822d9575d4ddf179da4ccfed6ca77151bef`.
- Archive manipulée sur l'hôte par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) seulement ; aucun code du paquet n'a tourné sur l'hôte. Le comparateur `bin/compare_csv.py` (code de confiance) lit des CSV sur l'hôte.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture (`run/`, `run2/`), l'original reste dans `pkg/`. Les sorties livrées sont supprimées de la copie avant l'exécution.
- Politique de sortie de l'hôte (port 25 refusé, débit limité, journalisation) vérifiée dans cette session : `politique_sortie.log` (`sudo nft list ruleset`).

## Résultats

### Paquet tel que livré (`lance_run.sh`, `run1_telle_que_livree.out`)

1. `python3 run_all.py` dans l'image `replab-fiscal` : `01_build_master.py` terminé en 4 s ; `20_baseline.py` échoue : `TypeError: only 0-dimensional arrays can be converted to Python scalars`, trace dans `pydynpd/specification_tests.py`, ligne 16 (`float(hansen_test)`), appelée depuis `code/est_core.py` ligne 192 (`regression.abond`) ; `run_all.py` s'arrête (« 20_baseline.py failed ») ; code de la commande conteneur : 1 ; durée 12 s.
2. Cause établie par `diagnostic_numpy.log` : dans cette image, `float(numpy.array([[1.0]]))` lève la même `TypeError` (numpy 2.5.3, code 1). Même échec avec numpy 2.4.4 (`build_corrige.log`, « code de sortie test float : 1 »). Avec numpy 2.3.5, la même instruction réussit (`build_corrige_235b.log`, « code de sortie test float : 0 »).

### Hors paquet (`Containerfile.corrige`, `lance_build_corrige.sh`, `lance_run_corrige.sh`)

Correction exacte : dans la liste d'installation, `numpy==2.3.5` au lieu de `numpy==2.5.3` ; toutes les autres lignes et le code du paquet sont inchangés. Image `replab-fiscal-corrige` (sha256 de l'archive `~/images/zenodo-24141273-corrige.tar` : `9ed14c6d59c8abde4a8ace86b79c426aab08810015b5f78c84bae9994e634a45`, `build_corrige_235b.log`). Il s'agit d'une version de numpy antérieure à celle que le paquet épingle : je ne sais pas avec quel numpy l'auteur a produit ses sorties.

3. `python3 run_all.py` : tous les pas de 01 à 58 terminés, « all steps completed », code 0, durée 2 849 s (`run2_corrige.out`), 8 cœurs (`nproc`).
4. Comparaison (`compare.sh`, `compare2.log`) : listes de fichiers de `output/` livré et régénéré identiques (0 fichier présent d'un seul côté). CSV, par `bin/compare_csv.py` à l'égalité exacte (atol = rtol = 0) : **88 comparés, 84 identiques, 4 différents** :
   - `results/multiverse_all.csv` : écarts de dernier chiffre significatif (par exemple ligne 2, colonne `se` : 0.20266335074901945 → 0.2026633507490196) ; identique à `--rtol 1e-9` (`compare_multiverse_tol.log`).
   - `tables/C2.csv` : quatre cellules « Seconds per fold » (temps de calcul, que le README dit varier).
   - `tables/C6.csv` : deux cellules, colonne « DML: Random Forest » 0.662 (0.439) → 0.661 (0.439), colonne « DML: Gradient Boosting » 0.467 (0.523) → 0.440 (0.536).
   - `tables/G1.csv` : une cellule, « Bootstrap p » 0.160 → 0.161.
5. Fichiers non CSV, comparés octet par octet (`cmp`) : 116 comparés, 55 identiques, 61 différents (29 figures PNG, 31 JSON de `results/`, `run_all.log`). Je n'ai pas de comparateur commun pour le JSON (article 5 bis) et je n'ai pas inspecté ces différences : je ne dis rien de leur ampleur. Les PNG ne sont pas comparés au pixel.

## Limites

- **Portée paquet.** L'article n'a pas été lu ; rien ici ne dit que les nombres de l'article sont retrouvés.
- Le verdict *inexécutable* est un fait sur le paquet tel que livré dans l'environnement qu'il épingle, pas sur la science. Je n'ai pas essayé d'autres versions de Python, ni une autre version de `pydynpd`.
- Les différences de `C6.csv` et de `G1.csv` ont lieu dans un environnement qui diffère de celui du paquet (numpy 2.3.5 au lieu de 2.5.3) ; je n'ai pas établi si elles viennent de cette différence, du matériel (8 cœurs ici, 2 chez l'auteur), ou d'autre chose.
- Une seule exécution de chaque commande ; pas de répétition.
- Notification : le verdict n'est pas *divergent*, aucune `NOTIFICATION.md` n'est rédigée. Aucune adresse électronique n'apparaît dans le paquet ni dans la fiche Zenodo (`adresse_paquet.log`, `grep` sans résultat, code de sortie 0 sous l'utilisateur `replab`, sur `pkg/` hors `output/`).
- Les fichiers `compare.log` et `suivi*.log` sont des états intermédiaires : `compare.log` provient d'une première version de `compare.sh` dont le récapitulatif est faux (voir l'en-tête du script) ; les décomptes font foi dans `compare2.log`.

## Commandes

Appels exacts en tête de chaque script, depuis la racine du dépôt : `telecharge_extrait.sh` → `telechargement.log` ; `lance_build.sh` + `Containerfile` → `build.log` ; `lance_run.sh` (détaché par `bin/lance_detache.sh`) → `run1_telle_que_livree.out` ; `lance_build_corrige.sh` + `Containerfile.corrige` → `build_corrige.log` (numpy 2.4.4), `build_corrige_235.log` (2.3.5, archivage en échec code 125), `build_corrige_235b.log` ; `lance_run_corrige.sh` → `run2_corrige.out` ; `compare.sh` → `compare2.log` ; comparaison à tolérance : `compare_multiverse_tol.log` (`python3 -I compare_csv.py --rtol 1e-9 …`). Lectures : `readme.log`, `zenodo_notice.json`, `adresse_paquet.log`.
