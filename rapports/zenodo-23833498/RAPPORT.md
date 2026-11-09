# Rapport zenodo-23833498 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Les commandes de `REPRODUCIBILITY.md` / `Makefile` (`make all`, `make verify`) sont exécutées dans le même ordre, étape par étape, tout en code 0 (`run.log`). Les trois fichiers JSON de résultats livrés sont régénérés : 643, 10 560 et 510 feuilles, mêmes chemins des deux côtés ; `extended_results.json` est identique à l'octet, les deux autres diffèrent par 2 et 9 feuilles numériques, au plus de 5,7·10⁻¹⁴ en absolu (`archetype_results.json`) et de 2,5·10⁻¹³ en relatif (`robustness_results.json`) (`compare.log`, `compare_json.log`). `verify.py` du paquet : toutes les vérifications OK, code 0 (`run.log`). Les huit figures régénérées diffèrent des figures livrées à l'octet ; elles n'ont pas été comparées autrement (Résultats, point 5). La portée *paquet* ne dit rien des nombres de l'article, qui n'a pas été lu : `verify.py` compare aux valeurs que le paquet dit être celles de l'article (art. 6 ter).

Couverture : *régénération* (les trois JSON livrés sont régénérés et comparés feuille par feuille ; les figures sont régénérées mais seulement comparées à l'octet).

## Paquet

- Zenodo 23833498, « Replication Package: Who Owns Granularity? Brand Data, Decision Rights, and Interdepartmental Conflict in Multinational Consumer Goods Firms », publié le 2026-10-31, trois auteurs (Recio-Román, Recio-Menéndez, Román-González), type logiciel, accès ouvert, licence MIT. Fiche : `rapports/zenodo-recherche-20261102/recherche.json` (`bin/fiche_zenodo.sh` l'extrait).
- Un fichier, `replication_package.zip`, 2 870 335 octets ; MD5 de la fiche (65a259b6…) concordant avec le fichier téléchargé (`telechargement.log`, ligne « OK ») ; 20 fichiers extraits, code d'extraction 0 (`telechargement.log`).
- Données : aucune donnée tierce (README, `readme.log`, section « Data ») ; le paquet est une simulation de Monte-Carlo dont tout nombre est fonction du code et de la graine 20260823.
- Dépendances figées par le paquet (`readme.log`) : numpy 2.4.4, scipy 1.17.1, matplotlib 3.10.9 ; le paquet dit avoir été vérifié sur Python 3.12.3.
- Durée annoncée : « environ 25 minutes sur un cœur » (`readme.log`). Durées mesurées par étape (`run.log`, lignes « durée … (s) ») : 7, 6, 32, 8, 3, 0 et 1 s, soit une minute environ au total. Je ne l'explique pas ; je ne fais pas d'hypothèse.

## Environnement

- sd-92569, podman sans root. Image `replab-granularity` construite (réseau : PyPI, construction seulement) depuis `docker.io/library/python:3.12-slim` avec les trois versions du `requirements.txt` du paquet (`Containerfile`, `lance_build.sh`, `build.log`). Versions mesurées (`build.log`) : Python 3.12.15, numpy 2.4.4, scipy 1.17.1, matplotlib 3.10.9 (donc identiques aux versions du paquet sauf Python, 3.12.15 contre 3.12.3).
- Archive manipulée sur l'hôte uniquement par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) ; aucun code du paquet n'a tourné sur l'hôte. Les JSON ont été comparés sur l'hôte par `python3 -I compare_json.py`, qui ne lit que du JSON.
- Politique de sortie de l'hôte relevée avant l'exécution (`politique_sortie.log`, `sudo nft list ruleset`) : ports 25, 465, 587 refusés (lignes 157-159 et 373-375), nouvelles connexions de l'utilisateur 1001 journalisées (table `inet replab`). Le plafond de débit (`tc`) n'a pas été relu cette fois.
- Exécution : conteneur `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seul `run/` monté en écriture (copie du paquet ; l'original extrait reste intact dans `pkg/`) (`lance_run.sh`, `run.log`). Aucun réseau pendant l'exécution, aucun secret à bord.
- Image sans make : les recettes du `Makefile` sont exécutées à la main dans le même ordre (`archetypes.py`, `extended_analyses.py`, `robustness_analyses.py`, `archetype_figures.py`, `extended_figures.py`, les huit `mv` et le `rm`, puis `verify.py`). Écart avec `make verify`, qui dépend de `results` et relancerait les trois simulations : je lance `verify.py` une seule fois, sur les JSON que `make all` vient de produire.

## Commandes

```
bin/capture.sh rapports/zenodo-recherche-20261102/recherche.json 'curl -s -m 60 "https://zenodo.org/api/records?q=%22replication+package%22+AND+access_right:open&sort=mostrecent&size=25&page=2&type=software"'
bash bin/liste_zenodo.sh rapports/zenodo-recherche-20261102/recherche.json
bash bin/fiche_zenodo.sh rapports/zenodo-recherche-20261102/recherche.json 23833498
scp rapports/zenodo-23833498/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23833498/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23833498/readme.log 'cd work/z23833498/pkg && cat REPRODUCIBILITY.md Makefile requirements.txt'
bin/capture.sh rapports/zenodo-23833498/verify_source.log 'cat ~/work/z23833498/pkg/verify.py'
bin/capture.sh rapports/zenodo-23833498/politique_sortie.log 'sudo nft list ruleset'
scp rapports/zenodo-23833498/lance_build.sh rapports/zenodo-23833498/Containerfile sd-92569:work/z23833498/
bin/capture.sh rapports/zenodo-23833498/build.log 'cd ~/work/z23833498 && sh lance_build.sh'
scp rapports/zenodo-23833498/lance_run.sh sd-92569:work/z23833498/
bin/capture.sh rapports/zenodo-23833498/run.log 'cd ~/work/z23833498 && sh lance_run.sh'
scp rapports/zenodo-23833498/compare.sh sd-92569:work/z23833498/
bin/capture.sh rapports/zenodo-23833498/compare.log 'cd ~/work/z23833498 && sh compare.sh'
scp rapports/zenodo-23833498/compare_json.sh rapports/zenodo-23833498/compare_json.py sd-92569:work/z23833498/
bin/capture.sh rapports/zenodo-23833498/compare_json.log 'cd ~/work/z23833498 && sh compare_json.sh'
```

## Résultats

1. **Exécution.** Les sept étapes sortent en code 0 (`run.log`, lignes « code … : 0 »). Les trois simulations impriment les tables du paquet ; exemples : prime de l'archétype A 5,3 soit 0,534 % des ventes, de B 471,2 soit 0,524 % ; part « résolution » 91 % et 93 % ; D* 0,706 et 0,617 (`run.log`). Les figures s'écrivent (huit PNG dans `run/figures/`).
2. **`verify.py`.** Douze comparaisons numériques, tolérance absolue 0,006 (`verify_source.log`), toutes « OK » ; exemples (obtenu / valeur du paquet) : prime A 0,5344 / 0,5340, prime B 0,5236 / 0,5240, D* A 0,7057 / 0,7100, q de B 0,5658 / 0,5660, prime A à β = 0 0,0991 / 0,0990 ; l'ordre des mécanismes M2 < M4 < M3 < M5 aux deux échelles, la dominance de la gouvernance centralisée à chaque β et l'invariance de la composante de maturité sont OK ; « All checks passed », code 0 (`run.log`). Chaque écart est jugé par `verify.py` lui-même contre la tolérance de 0,006 ; je n'en ai calculé aucun moi-même. Les valeurs de référence sont arrondies à deux ou trois décimales dans `verify.py` : la vérification est faite à cette précision.
3. **JSON livrés / régénérés, à l'octet** (`compare.log`) : `extended_results.json` identique ; `archetype_results.json` et `robustness_results.json` différents.
4. **JSON, feuille par feuille** (`compare_json.log`). `archetype_results.json` : 643 feuilles des deux côtés, 2 différentes (`scale_curve[0]/territories` et `/complexity`), écart absolu maximal 5,68·10⁻¹⁴, relatif 1,81·10⁻¹⁶. `robustness_results.json` : 510 feuilles, 9 différentes (toutes dans `joint_sensitivity`), écart absolu maximal 2,28·10⁻¹⁴, relatif 2,53·10⁻¹³. `extended_results.json` : 10 560 feuilles ; le script en compte 114 « différentes », qui sont des `nan` (le script compare par `!=`, or `nan != nan`) ; les quinze premières imprimées le sont (`corner_A/critical_c_share[13…27]`), les autres ne sont pas relevées une à une, mais le fichier est identique à l'octet (point 3), ce qui exclut tout écart réel. Les chemins sont les mêmes des deux côtés dans les trois fichiers.
5. **Figures.** Les huit PNG régénérés diffèrent à l'octet des huit livrés (`compare.log`). `archetype_figures.py` imprime en continu des avertissements `findfont` (police « serif » absente de l'image, repli sur DejaVu Sans ; `run.log`) ; je n'ai pas vérifié que cela explique les différences, ni comparé les images à l'œil ni pixel à pixel. Le paquet dit lui-même que matplotlib n'entre dans aucun nombre rapporté (`readme.log`).
6. **Répétabilité.** Une seule exécution complète. Le paquet annonce une exécution déterministe à graine fixe ; la comparaison aux fichiers livrés (points 3 et 4) en est la seule vérification.

## Limites

- **Portée.** *Paquet* : les JSON de résultats du paquet sont régénérés par son code, au dernier chiffre flottant près (points 3-4). Aucune comparaison avec l'article (non inclus, non lu) ; `verify.py` ne fait que comparer à des valeurs arrondies qu'il dit être celles de l'article.
- **Écart de durée.** environ une minute mesurée contre 25 min annoncées : non expliqué.
- **Figures.** Régénérées, non comparées sur leur contenu ; elles diffèrent à l'octet.
- **Environnement.** Python 3.12.15 contre 3.12.3 pour le paquet ; une seule machine, une seule exécution.
- **Contenu non examiné.** Je n'ai pas lu les scripts de simulation ni jugé la validité du modèle, de sa calibration (ancrée sur des comptes publiés d'une entreprise non nommée, selon le README) ni des figures.
- Les sorties de l'exécution restent sur sd-92569 (`~/work/z23833498/run`, `pkg`) ; seuls les logs sont copiés ici.
- Aucun auteur n'est notifié : le verdict proposé n'est pas *divergent* (art. 6).
