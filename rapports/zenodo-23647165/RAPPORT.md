# Rapport zenodo-23647165 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Dans un conteneur sans réseau, avec le jeu de données public que le README désigne (figshare 25311358, quatre fichiers, MD5 vérifiés), `verify_theory.py` et `calibrate.py` (les deux premières étapes de `make.sh`) sortent avec le code 0 après suppression préalable de quatre fichiers de `output/` (`verification.json`, `results.json`, `numbers_in_text.json`, `calibration_log.txt`, selon `lance_run.sh`), dont trois sont recréés par ces deux étapes et un (`numbers_in_text.json`) ne l'est pas ; `verification.json` est recréé identique octet à octet, `results.json` est recréé avec les mêmes 2 077 valeurs à un écart relatif maximal de 8,8e-12 près, `calibration_log.txt` ne diffère que par les derniers chiffres de 3 nombres sur deux lignes. Les figures, les documents LaTeX et `numbers_in_text.json` ne sont pas régénérés (voir Limites).

Couverture : *régénération* (les sorties livrées sont régénérées et comparées) pour `verification.json`, `results.json` et `calibration_log.txt` ; pas pour `numbers_in_text.json`, ni pour les figures PDF.

## Paquet

- Zenodo 23647165, « Replication package for "A parity frontier between fully renewable electrified and hydrocarbon energy systems: the required EROI under changing final energy demand" », publié le 2026-10-25, deux auteurs (Université Mohammed VI Polytechnique), type logiciel, accès ouvert, licence MIT. Fiche : `bin/capture.sh rapports/zenodo-23647165/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23647165'`.
- Un fichier, `Benyahia_EROI_frontier_replication_package.zip`, 963 240 octets ; MD5 de la fiche concordant (`telechargement.log`, ligne « OK ») ; 32 fichiers extraits, code d'extraction 0 (même fichier).
- Données : **non incluses** dans le paquet (« The dataset is not redistributed here », `readme.log`) ; le README renvoie au jeu de données Aramendia et al. 2024, figshare 25311358, public, licence CC BY 4.0, sans inscription (`figshare_fiche.json`, `"is_public": true`, `"download_disabled": false`). Il est en accès public direct (art. 1) : dans le périmètre. Les quatre fichiers que le README demande ont été téléchargés par `curl` depuis `ndownloader.figshare.com`, MD5 de la fiche figshare vérifiés (`telechargement_donnees.log`, quatre « OK »).
- Dépendances : « Python 3.10 or later with numpy, scipy and matplotlib ; pdflatex… » (`readme.log`) ; aucune version fixée.

## Environnement

- sd-92569, podman sans root. Image `replab-eroi` (`Containerfile`, `lance_build.sh`, `build.log`) : **Python 3.13.18, numpy 2.5.4, scipy 1.18.1** (versions les plus récentes à la date de construction ; le paquet n'en fixe aucune). matplotlib et LaTeX **ne sont pas** dans l'image.
- Archive et données manipulées sur l'hôte par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) seulement ; aucun code du paquet n'a tourné sur l'hôte.
- Politique de sortie de l'hôte en place avant l'exécution : `politique_sortie.log`.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture, données montées en lecture seule ; l'original reste dans `pkg/`.

## Résultats

1. **Vérification théorique** (`lance_run.sh`, `run.log`, lignes 5-40) : `python3 verify_theory.py ../output` sort avec le code 0 en 20 s ; 32 lignes `[ok]` et « ALL CHECKS PASSED ». `verification.json` régénéré : `"n_checks": 32, "all_passed": true, "max_rel_error": 0.002092182882983267` (`valeurs_cles.log`) ; `cmp` avec le fichier livré : code 0, donc identique octet à octet (`run.log`, lignes 49-50).
2. **Calibration** (`lance_run.sh`, `run.log`, ligne 41-42) : `python3 -I calibrate.py /data ../output > ../output/calibration_log.txt` sort avec le code 0 en 2 s. Quatre fichiers (`verification.json`, `results.json`, `numbers_in_text.json`, `calibration_log.txt`) ayant été supprimés de la copie avant l'exécution (`lance_run.sh`, ligne 12), `verification.json`, `results.json` et `calibration_log.txt` sont recréés (`run.log`, lignes 43-47) ; `numbers_in_text.json` reste absent (`cmp` code 2, `run.log`, lignes 55-56) car son producteur, `build_manuscript.py`, n'a pas été exécuté.
3. **`results.json`** (`compare_json.py`, `compare_results.log`) : 2 077 valeurs de chaque côté, aucune valeur absente d'un côté, 1 912 identiques, 165 numériques différentes, aucune non numérique différente ; écart relatif maximal 8,8e-12 (écart absolu maximal 8,53e-14), sur `/g_star/gamma4/4.6` (0,00045605788220989184 livré, 0,00045605788221390485 régénéré). `cmp` seul signale une différence d'octets (`run.log`, ligne 52) : le fichier n'est donc pas identique octet à octet.
4. **`calibration_log.txt`** (`diff_calibration_log.log`) : deux lignes diffèrent (141 et 144), uniquement dans les derniers chiffres de trois nombres (3,76491010029074 / 3,7649101002907397 ; 3,8430531833113695 / 3,8430531833113686 ; 3,6257676455775987 / 3,6257676455775982). Le reste du fichier est identique.
5. **Chiffre cité par la description Zenodo** : « the baseline requirement at 2% annual growth is 5.5 ». Le tableau régénéré (`tableau_requis.log`, lignes 10-11) donne, pour le scénario `baseline` en colonne « +2% », 5,48. Le chiffre est retrouvé à l'arrondi près ; je n'ai pas lu l'article.

## Limites

- **Portée paquet.** L'article n'a pas été lu (art. 6 ter) : le rapport dit que des sorties du paquet sont régénérées, pas que les nombres de l'article sont retrouvés.
- **Étapes non exécutées** : `figures.py` (backend matplotlib « pgf » : demande pdflatex), `graphical_abstract.py`, `build_manuscript.py`, la compilation LaTeX de `make.sh`. LaTeX et matplotlib ne sont pas dans l'image ; je ne les ai pas ajoutés. Les figures PDF, `numbers_in_text.json` (produit par `build_manuscript.py` : il n'apparaît pas après les deux étapes exécutées, `run.log`, ligne 55) et les documents ne sont pas régénérés ni comparés ; je ne dis rien d'eux.
- **Écarts numériques.** Les différences du point 3 sont à la précision de la machine ; le paquet ne fournit pas de critère de tolérance. Elles sont compatibles avec une autre version de numpy/scipy que celle de l'auteur (que le paquet ne note pas) ; je n'ai pas cherché à l'établir.
- **Versions non fixées** : numpy 2.5.4 et scipy 1.18.1 sont celles d'aujourd'hui. Une autre date de construction peut donner d'autres écarts.
- **Dépendance à un jeu externe** : le résultat vaut pour les quatre fichiers figshare dont les MD5 sont ceux de la fiche figshare (`telechargement_donnees.log`) ; la fiche indique la version 1, du 2024-05-20 (`figshare_fiche.json`).
- **`verify_theory.py` vérifie des identités du modèle par calcul** (tirages aléatoires, quadratures) : je constate que les 32 contrôles passent, pas que la théorie est correcte.
- Une seule exécution complète sur une machine ; pas de répétition.

## Commandes

```
bin/capture.sh rapports/zenodo-23647165/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/23647165'
scp rapports/zenodo-23647165/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23647165/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23647165/readme.log 'cat work/z23647165/pkg/replication/README.md work/z23647165/pkg/replication/code/README.md work/z23647165/pkg/replication/code/make.sh'
bin/capture.sh rapports/zenodo-23647165/figshare_fiche.json 'curl -sS -m 60 https://api.figshare.com/v2/articles/25311358'
scp rapports/zenodo-23647165/telecharge_donnees.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23647165/telechargement_donnees.log 'sh work/telecharge_donnees.sh'
bin/capture.sh rapports/zenodo-23647165/politique_sortie.log 'sudo nft list table inet replab; sudo nft list chain ip filter ufw-user-output'
bin/capture.sh rapports/zenodo-23647165/imports.log 'cd work/z23647165/pkg/replication/code && grep -n -E "^(import|from)|pdflatex|subprocess|requests|urllib|socket" *.py'
scp rapports/zenodo-23647165/lance_build.sh rapports/zenodo-23647165/Containerfile sd-92569:work/z23647165/
bin/capture.sh rapports/zenodo-23647165/build.log 'cd ~/work/z23647165 && sh lance_build.sh'
scp rapports/zenodo-23647165/lance_run.sh sd-92569:work/z23647165/
bin/capture.sh rapports/zenodo-23647165/run.log 'cd ~/work/z23647165 && sh lance_run.sh'
scp rapports/zenodo-23647165/compare_json.py sd-92569:work/z23647165/
bin/capture.sh rapports/zenodo-23647165/compare_results.log 'cd ~/work/z23647165 && python3 -I compare_json.py pkg/replication/output/results.json run/output/results.json'
bin/capture.sh rapports/zenodo-23647165/diff_calibration_log.log 'cd ~/work/z23647165 && diff pkg/replication/output/calibration_log.txt run/output/calibration_log.txt'
bin/capture.sh rapports/zenodo-23647165/valeurs_cles.log 'cd ~/work/z23647165 && cat run/output/verification.json && grep -n -i -E "baseline|5\.4[0-9]|5\.5" run/output/calibration_log.txt | head -20'
bin/capture.sh rapports/zenodo-23647165/tableau_requis.log 'cd ~/work/z23647165 && sed -n 1,9p run/output/calibration_log.txt'
```

Note de session : un premier appel `bin/capture.sh rapports/zenodo-23647165/fiche_zenodo.json 'true'` a écrit par erreur une capture vide ; le fichier a été réécrit aussitôt par la commande ci-dessus (il contient la commande réelle en en-tête).
