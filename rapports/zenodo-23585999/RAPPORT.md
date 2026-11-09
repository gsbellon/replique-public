# Rapport zenodo-23585999 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Les trois commandes du README du paquet (`verify_release.py --manifest`, `run_all.py`, `verify_release.py`) s'exécutent jusqu'au bout, code 0 ; les 39 programmes de `run_all.py` sortent en code 0 ; sur les 89 fichiers de résultats que l'exécution a réécrits, 50 sont identiques à l'octet à ceux du paquet et 39 diffèrent, uniquement par des durées, des empreintes de fichiers qui diffèrent, des chaînes d'environnement et des écarts d'arrondi flottant (le plus grand écart relatif sur 11 245 cellules de CSV : 9,58·10⁻¹⁴) ; une seule valeur numérique de JSON dépasse 10⁻⁹ en relatif et 10⁻¹² en absolu (voir Résultats, point 4). La portée *paquet* ne dit rien des nombres de l'article, qui n'a pas été lu (art. 6 ter).

Couverture : *régénération* (les fichiers de résultats réécrits par `run_all.py` sont comparés à ceux du paquet : 89 fichiers, dont 50 identiques à l'octet).

## Paquet

- Zenodo 23585999, « Replication package: AI Income Rights and the Identification of Declining Work », version v0024, publié le 2026-10-23, auteur Craig Steven Wright (University of Exeter), type logiciel, accès ouvert. Fiche : `bin/capture.sh rapports/zenodo-23585999/fiche_zenodo.json 'curl -s -m 60 https://zenodo.org/api/records/23585999'`. Instructions du dépôt : `download_and_extract.log` (`curl -s -m 60 https://zenodo.org/api/records/23585999/files/DOWNLOAD_AND_EXTRACT.txt/content`, même méthode).
- Trois ZIP numérotés (4 250 050 + 26 941 547 + 25 593 145 octets), à extraire dans un même dossier vide : 222 fichiers (`fichiers.json`, `fiche_zenodo.json`). Les MD5 de la fiche concordent avec les fichiers téléchargés (`telechargement.log`, quatre lignes « OK » en tête) ; ARTIFACT_HASHES.json annonce 222 entrées pour l'archive complète ; 222 fichiers extraits (`telechargement.log` : `find . -type f | wc -l` imprime 222), codes d'extraction 0 pour les trois archives.
- Données incluses : les deux archives SCF 2022 et 2025 de la Réserve fédérale sont dans le paquet (`sources/`) ; aucun téléchargement, aucune inscription, aucun formulaire (art. 1). Pas de licence accordée pour le code de l'auteur (README, `readme.log` : « No additional MIT, Creative Commons or other license is silently granted ») : le projet exécute et rapporte, il ne redistribue pas le paquet.
- Le README (`readme.log`) annonce : Python 3.12.14 et numpy 2.3.5, scipy 1.17.0, pandas 2.2.3, matplotlib 3.10.8, mpmath 1.3.0 ; `verify_release.py --manifest` avant, `run_all.py` (39 programmes), `verify_release.py` après ; « PDFs and run receipts can change bytewise because of dates and execution timing ».

## Environnement

- sd-92569, podman sans root. Image `replab-ai306` construite (réseau : PyPI, construction seulement) depuis `docker.io/library/python:3.12-slim` avec `requirements-lock.txt` du paquet (`Containerfile`, `lance_build.sh`, `build.log`). Versions mesurées dans l'image (`build.log`) : Python **3.12.15** (le README dit 3.12.14), numpy 2.3.5, scipy 1.17.0, pandas 2.2.3, matplotlib 3.10.8, mpmath 1.3.0, donc identiques au lock hors la version corrective de Python.
- Archives manipulées sur l'hôte uniquement par `curl` et `python3 -I` (`zipfile.extractall`, `telecharge_extrait.sh`) ; aucun code du paquet n'a tourné sur l'hôte.
- Exécution : conteneur `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seul `run/` monté en écriture (copie du paquet ; l'original extrait reste intact dans `pkg/` pour la comparaison) (`lance_run.sh`, `lancement.log`). Aucun réseau pendant l'exécution, aucun secret à bord.

## Commandes

```
scp rapports/zenodo-23585999/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23585999/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23585999/readme.log 'cat work/z23585999/pkg/README.md work/z23585999/pkg/requirements.txt work/z23585999/pkg/requirements-lock.txt'
scp rapports/zenodo-23585999/lance_build.sh rapports/zenodo-23585999/Containerfile sd-92569:work/z23585999/
bin/capture.sh rapports/zenodo-23585999/build.log 'cd ~/work/z23585999 && sh lance_build.sh'
scp rapports/zenodo-23585999/lance_run.sh sd-92569:work/z23585999/
bin/capture.sh rapports/zenodo-23585999/lancement.log 'cd ~/work/z23585999 && sh lance_run.sh'
bin/capture.sh rapports/zenodo-23585999/attente_run.log 'timeout 900 podman wait replab-ai306-run; podman ps -a --filter name=replab-ai306-run; podman logs replab-ai306-run | tail -n 40'
scp rapports/zenodo-23585999/compare_pkg_run.py rapports/zenodo-23585999/compare_csv.py sd-92569:work/z23585999/
bin/capture.sh rapports/zenodo-23585999/comparaison_exact.log 'cd ~/work/z23585999 && python3 -I compare_pkg_run.py pkg run 0'
bin/capture.sh rapports/zenodo-23585999/comparaison_1e-9.log 'cd ~/work/z23585999 && python3 -I compare_pkg_run.py pkg run 1e-9'
bin/capture.sh rapports/zenodo-23585999/comparaison_1e-6.log 'cd ~/work/z23585999 && python3 -I compare_pkg_run.py pkg run 1e-6'
bin/capture.sh rapports/zenodo-23585999/comparaison_1e-2.log 'cd ~/work/z23585999 && python3 -I compare_pkg_run.py pkg run 1e-2'
bin/capture.sh rapports/zenodo-23585999/comparaison_1e-9_abs1e-12.log 'cd ~/work/z23585999 && python3 -I compare_pkg_run.py pkg run 1e-9 1e-12'
bin/capture.sh rapports/zenodo-23585999/comparaison_csv.log 'cd ~/work/z23585999 && python3 -I compare_csv.py pkg run base_v0008/analysis/ownership_tail_paths.csv base_v0008/scf_pilot/equity_threshold_sensitivity.csv base_v0008/scf_pilot/labor_status_by_age_and_ownership.csv base_v0008/scf_pilot/weighted_descriptive_estimates.csv base_v0008/scf_uncertainty/descriptive_estimates_with_standard_errors.csv'
bin/capture.sh rapports/zenodo-23585999/diff_logs.log '<boucle diff sur les huit journaux, voir la première ligne du log>'
bin/capture.sh rapports/zenodo-23585999/fichiers_reecrits.log 'cd ~/work/z23585999/run; date -u; find . -type f -newermt "2026-10-29 20:05:00 UTC" | sort'
bin/capture.sh rapports/zenodo-23585999/reecrits_identiques.log '<deux find -exec, voir la première ligne du log>'
```

`diff_csv.log` (aperçu des diffs de CSV) est conservé comme trace de la démarche ; aucun nombre du rapport n'en dépend. `etat_1.log` est le premier relevé d'état (conteneur « Up »).

## Résultats

1. **Vérifications du paquet.** `verify_release.py --manifest` avant exécution : « status: passed », 5 fichiers d'entrée vérifiés, 44 775 lignes et 31 colonnes dans le sous-ensemble, 4 595 familles en 2022 et 4 360 en 2025, `manifest_checked: true`, code 0 (`lancement.log`). `run_all.py` : « All 39 scientific/figure programs passed », code 0 ; `verify_release.py` après : mêmes décomptes, `manifest_checked: false` (attendu après régénération), code 0 (`attente_run.log`). Le conteneur était terminé à la fin d'une attente de 194 s lancée 13 s après le démarrage (`attente_run.log`, « durée (s) » ; démarrage 20:05:01Z dans `lancement.log`, début de l'attente 20:05:14Z) : l'exécution a duré au plus 3 min 27 s (13 + 194 = 207 s ; correction du 2026-10-30 après relecture, qui indiquait 9 s et 3 min 21 s).
2. **Fichiers réécrits.** Le paquet contient 222 fichiers (`comparaison_exact.log`). L'exécution a réécrit **89** fichiers du paquet (date de modification postérieure au lancement) et 21 nouveaux (`reecrits_identiques.log`, première valeur : 89 ; `fichiers_reecrits.log`, 110 lignes de chemin au total, dont 20 nouveaux journaux de `full_run_logs/20261029T200501545002Z/` ; le 21ᵉ fichier de la liste de 110 est `release_run_logs/mplconfig/fontlist-v390.json`, absent du paquet extrait). Sur ces 89 : **50 identiques à l'octet** (`reecrits_identiques.log`, deuxième liste) et **39 différents** (`comparaison_exact.log` : 5 CSV, 9 journaux `.log`, 3 PDF, 1 SVG, 21 JSON). Les 133 autres fichiers identiques du paquet (183 − 50) n'ont pas été réécrits : scripts, sources, documents ; leur identité ne prouve rien au titre de la régénération.
3. **CSV.** Les 5 CSV qui diffèrent comptent au total 11 245 cellules, dont 822 diffèrent en valeur ; aucune cellule non numérique ne diffère ; le plus grand écart relatif est **9,58·10⁻¹⁴** (`descriptive_estimates_with_standard_errors.csv`), le plus grand écart absolu hors `ownership_tail_paths.csv` (valeurs de l'ordre de 10²³) est de 1,16·10⁻¹⁰ (`comparaison_csv.log`, somme des cinq lignes).
4. **JSON.** 21 JSON diffèrent à l'octet (`comparaison_exact.log`). Avec une tolérance relative de 10⁻⁹ **ou** absolue de 10⁻¹² (`comparaison_1e-9_abs1e-12.log`), 16 deviennent égaux ; les 5 restants sont : `base_v0008/REPRODUCTION_RECEIPT.json` (durées d'exécution et empreintes SHA-1 des journaux), `inverse_region_audit_20261019/results.json` (chaîne de version de Python), `scf_uncertainty/validation.json` (version de Python, plateforme), `JOINT_VALUE_REPRODUCTION_RECEIPT.json` (plateforme, Python, durées, empreintes de PDF et de journal, date de l'exécution) et `joint_value_independent.json` (plateforme, version de Python, et **une valeur numérique** : `utility_optimizer_max_spending_difference`, 1,0145·10⁻⁸ livrée contre 1,1717·10⁻⁸ régénérée). Cette dernière est un écart d'optimiseur entre deux méthodes du paquet, de l'ordre de 10⁻⁸ dans les deux exécutions ; je ne l'ai pas rattachée à une cause (version de Python, bibliothèque numérique, plateforme) ; son seul rôle dans le paquet que j'aie vu est d'être imprimée dans le journal `joint_value_independent.stdout.log` (`comparaison_exact.log`).
5. **Journaux.** 9 journaux diffèrent ; sur les huit relevés dans `diff_logs.log`, les écarts montrés (6 premières lignes de diff par fichier) sont des derniers chiffres de valeurs flottantes ou la chaîne de version de Python ; le neuvième est le journal de `joint_value_independent` (point 4).
6. **PDF, SVG.** 3 PDF et 1 SVG diffèrent à l'octet ; les PNG correspondants (`flagship_linked_information.png`, `joint_hours_price_value.png`, `finite_counterfactual_geometry_paths.png`) sont identiques à l'octet (`reecrits_identiques.log`). Je n'ai pas examiné le contenu des PDF et du SVG ; le README dit qu'ils peuvent varier à l'octet (dates).

## Limites

- **Portée.** *Paquet* : les fichiers de résultats du paquet sont régénérés par son code (89 réécrits, 50 identiques à l'octet, 39 égaux aux arrondis, durées et empreintes près, hors la valeur du point 4). Aucune comparaison avec l'article ni avec le manuscrit v0024 (non inclus dans le paquet, non lu). Le contrôle `MANUSCRIPT_SCF_TABLE7_CHECK.json` du paquet n'a pas été audité ici.
- **Une seule exécution.** Pas de seconde exécution : la répétabilité de la régénération n'est pas mesurée.
- **Environnement.** Python 3.12.15 au lieu de 3.12.14 ; noyau, libc et compilateur de Python diffèrent de ceux de l'auteur (chaînes de plateforme dans les points 4 et 5). Les écarts d'arrondi relevés sont cohérents avec cela, sans que j'aie isolé la cause.
- **Ce que `verify_release.py` mesure** est ce que le paquet y a mis (empreintes des entrées, décomptes, exclusions) ; ce rapport s'appuie sur sa sortie telle qu'imprimée, sans avoir relu son code.
- **Contenu non examiné.** Les 39 programmes sont des calculs de modèle et de bornes ; je n'ai pas jugé leur validité scientifique, ni les formules, ni ce que les « certificats » établissent. Le README précise que les exemples de la théorie sont synthétiques et que l'exercice SCF est descriptif.
- Les sorties de l'exécution restent sur sd-92569 (`~/work/z23585999/run`, `pkg`) ; seuls les logs de comparaison sont copiés ici.
- Aucun auteur n'est notifié : le verdict n'est pas *divergent* (art. 6).
