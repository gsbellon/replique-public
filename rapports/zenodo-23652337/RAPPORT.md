# Rapport zenodo-23652337 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. La vérification rapide du README (`reproduce_key_numbers.py`) s'exécute en 16 s dans un conteneur sans réseau, code 0, et affiche `20/20 checks passed` (`run.log`). La régénération des figures (`make_figures.py`), après suppression du cache livré, s'exécute jusqu'au bout (code 0, 17 s) et recalcule le cache `fig_cache.npz` avec un écart relatif maximal de 4,9e-16 sur le tableau `Pi` et un écart nul sur `As` et `Rho` (`figures.log`). Ce rapport ne compare pas à l'article (non lu, art. 6 ter) : les valeurs « reported » sont celles écrites en dur dans le script du paquet. Les tolérances de ce script sont celles de l'auteur ; plusieurs sont larges (voir Limites).

Couverture : *contrôles internes* (le paquet compare ses résultats recalculés à des valeurs conservées dans son script) ; pour le cache de figures, *régénération* d'un seul fichier livré (`fig_cache.npz`).

## Paquet

- Zenodo 23652337, « Replication package: Reach, not speed, limits who benefits from AI testing tools and where vendors invest », publié le 2026-10-26, un auteur (Hanyang University), type logiciel, accès ouvert, licence MIT. Fiche : `bin/capture.sh rapports/zenodo-23652337/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23652337'`.
- Un fichier, `replication_package.zip`, 949 147 octets (fiche) ; MD5 de la fiche concordant avec le fichier téléchargé (`telechargement.log`, ligne « OK ») ; 38 fichiers extraits, code d'extraction 0 : 22 scripts Python, 5 CSV de données dérivées, 5 figures PNG et `fig_cache.npz`, `README.md`, `requirements.txt`, `download_data.sh`, `LICENSE`.
- Données : les CSV dérivés sont inclus ; les données brutes publiques (dump Jira ~56 Go, Hugging Face) ne sont pas redistribuées (README, `readme.log`). Elles ne sont pas nécessaires aux deux vérifications exécutées ici ; les analyses de données publiques (`jira_extract_bugs.py`, etc.) n'ont **pas** été exécutées. Art. 1 : dans le périmètre.
- Dépendances : README « Python 3.13 (3.11+ should work) » ; `requirements.txt` avec bornes inférieures.

## Environnement

- sd-92569, podman sans root. Image `replab-reach` construite par `Containerfile` / `lance_build.sh` à partir de `python:3.13-slim` avec les paquets de `requirements.txt` sauf `pymc`, `arviz` et `pymongo` (réservés par le README à `nhpp_llm_econ.py`, `coverage_check.py`, `sensitivity.py`, `jira_extract_bugs.py`, non exécutés). Réseau seulement pendant la construction (code 0). Versions résolues le 2026-11-06 (`build.log`) : Python 3.13.18, numpy 2.5.4, scipy 1.18.1, pandas 3.1.1, matplotlib 3.11.2, pyarrow 26.0.1, statsmodels 0.15.0. Les versions de l'auteur ne sont pas connues.
- Archive manipulée sur l'hôte uniquement par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) ; aucun code du paquet n'a tourné sur l'hôte.
- Politique de sortie de l'hôte relevée (`politique_sortie.log`) : ports 25, 465, 587 refusés ; destinations journalisées pour l'utilisateur 1001 à 20 nouvelles connexions par seconde.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seule une copie du paquet (`run/`, `fig/`) montée en écriture ; l'original reste dans `pkg/`.

## Résultats

1. **Vérification rapide** (`lance_run.sh`, `run.log`). Code 0, 16 s, `20/20 checks passed`, 20 lignes `OK`, aucune `MISMATCH`. Exemples : Table 1, f̄ à A=0,5 : calculé 2,2320, annoncé 2,2000 ; Π*(1) = 5,7729 (identique) ; θ̂ = 46,1834 (annoncé 46,18) ; profit à A=1,0 (prix linéaire) : 5,7608 (annoncé 5,74) ; rapport de profits A=1,0 / A=0,9 : 5,5559 (annoncé 5,5) ; prix optimal à A=1,0 : 0,7980 (annoncé 0,80). Le script n'a modifié aucun fichier du paquet (`diff -rq pkg/replication_package run` vide, fin de `run.log`).
2. **Figures** (`lance_figures.sh`, `figures.log`). Cache supprimé, `make_figures.py` : code 0, 17 s (le README annonce 3 à 6 minutes) ; affiche θ̂ (vendor) = 46,18, θ_s (planner) = 65,09, λ* (A=0,9) = 0,485. Cinq PNG et un `fig_cache.npz` écrits. Comparaison du cache recalculé au cache livré (`compare_cache.py`, sortie de `figures.log`) : `As` et `Rho` identiques (57 valeurs), `Pi` écart absolu maximal 1,4e-17, relatif 4,9e-16. Les cinq PNG n'ont pas été comparés aux PNG livrés.

## Limites

- **Valeurs de référence internes.** Le script compare à des nombres qu'il contient ; je n'ai pas lu l'article, donc je ne dis pas que ces nombres sont ceux de l'article. Portée *paquet* seulement.
- **Tolérances de l'auteur, parfois larges** : 0,06·max(1, valeur/100) pour la Table 1 ; 0,05 sur 1,037 (profit à A=0,9) ; 0,1 sur 5,74 ; 0,3 sur le rapport 5,5 (calculé 5,5559) ; 0,3 sur θ̂ dans la ligne « max of Pi*(A)/c(A) ». Aucun contrôle ne dépasse sa tolérance ; je n'ai pas évalué si les tolérances sont justifiées. Écarts relatifs calculés à la main sur `run.log` : f̄ à A=0,5 : 1,5 % (2,2320 contre 2,2) ; rapport de profits : 1,0 % ; profit à A=1,0 : 0,4 % ; les autres lignes affichées s'écartent de moins de 0,5 %.
- **Couverture partielle du paquet.** Non exécutés : les analyses de données publiques (téléchargements de plusieurs Go, jeton GitHub exigé par l'une d'elles), la couche de régression NHPP (`pymc`), `coverage_check.py` (60 réplicats, « ~hours »), `sensitivity.py`, `vendor_dynamics.py`, `vendor_menu*.py` et les autres scripts de `code/`. Les CSV de `data/` n'ont pas été régénérés. Le verdict ne dit rien d'eux.
- **Figures non comparées pixel à pixel** : les PNG régénérés dépendent de la version de matplotlib (3.11.2 ici ; version de l'auteur inconnue).
- Les versions de bibliothèques sont les plus récentes à la date de construction ; le README ne fixe que des bornes inférieures. Pas essayé avec d'autres versions. Pas de seconde exécution de la vérification rapide.
- Les `reproduce_key_numbers.py` importent `kink_asymptotics` et `vendor_model` ; je n'ai pas relu ce code pour juger si les contrôles sont suffisants.

## Commandes

```
bin/capture.sh rapports/zenodo-23652337/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23652337'
scp rapports/zenodo-23652337/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23652337/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23652337/readme.log 'cat work/z23652337/pkg/replication_package/README.md work/z23652337/pkg/replication_package/requirements.txt'
scp rapports/zenodo-23652337/lance_build.sh rapports/zenodo-23652337/Containerfile sd-92569:work/z23652337/
bin/capture.sh rapports/zenodo-23652337/build.log 'cd ~/work/z23652337 && sh lance_build.sh'
scp rapports/zenodo-23652337/lance_run.sh sd-92569:work/z23652337/
bin/capture.sh rapports/zenodo-23652337/run.log 'cd ~/work/z23652337 && sh lance_run.sh'
bin/capture.sh rapports/zenodo-23652337/tolerances.log 'grep -n -E "tol|def check|passed|rtol|atol|cache|savez|savefig" work/z23652337/pkg/replication_package/code/reproduce_key_numbers.py work/z23652337/pkg/replication_package/code/make_figures.py'
bin/capture.sh rapports/zenodo-23652337/script_check.log 'cat work/z23652337/pkg/replication_package/code/reproduce_key_numbers.py'
scp rapports/zenodo-23652337/lance_figures.sh rapports/zenodo-23652337/compare_cache.py sd-92569:work/z23652337/
bin/capture.sh rapports/zenodo-23652337/figures.log 'cd ~/work/z23652337 && sh lance_figures.sh'
bin/capture.sh rapports/zenodo-23652337/politique_sortie.log 'sudo nft list table inet replab; sudo nft list chain ip filter ufw-user-output'
```

Recherche d'origine : `bin/capture.sh rapports/zenodo-recherche-20261105/recherche.json` (voir ce dossier), puis `bash bin/liste_zenodo.sh rapports/zenodo-recherche-20261105/recherche.json`. Choix du paquet : petit, Python, données dérivées incluses, script de vérification annoncé, ouvert ; non fondé sur l'auteur (art. 6 bis : l'auteur n'est pas dans la liste).

Chaque nombre ci-dessus provient du fichier nommé à côté de lui. Tous les `.log` ont été produits par `bin/capture.sh`.
