# Rapport zenodo-24331415 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**. Les contrôles rapides que le README du paquet documente (« Regenerate every number of the paper from the shipped results », « Regenerate the feeder graphs from the OpenDSS files »), exécutés dans un conteneur sans réseau avec les versions annoncées par le README (Python 3.11, numpy 2.1.1, scipy 1.13.1), régénèrent à l'octet près les fichiers livrés `paper/gen_results.tex`, `paper/gen_supp.tex`, `notes/numbers_provenance.md`, `notes/numbers_provenance_supp.md` et, à l'égalité exacte, les trois JSON de graphes de feeders (`ieee123_tree.json`, `ieee123_mesh.json`, `ieee8500_tree.json`).

Couverture : *régénération*, limitée à ces fichiers dérivés : les macros et notes sont recalculées à partir des fichiers de résultats livrés (`results/round2/`, 227 fichiers selon le README), qui ne sont **pas** régénérés. La réexécution complète (12,5 h sur 64 cœurs selon le README) n'a pas été tentée ; les calculs qui ont produit `results/round2/` n'ont pas été refaits, ni le noyau C, ni les figures, ni les autres auto-tests.

## Paquet

- Zenodo 24331415, « Code and data for "Lyapunov Certification as Max-Plus Inference: …" », v1, publié le 2026-11-18, type logiciel, accès ouvert, CC BY 4.0 (la fiche) ; un fichier `lyapunov-maxplus-certification-v1.0.0.zip`, 18 686 691 octets. Fiche : `fiche_zenodo.json`. MD5 de la fiche concordant (`telechargement.log`, « pkg.zip: OK »), 300 fichiers extraits, code 0. Script : `telecharge_extrait.sh`.
- README (`readme.log`) : le contrôle rapide 1 annonce les sommes `fcdc7cefe0ecb4006db2972f70b03e32` (`gen_results.tex`) et `b13be5402c056f03b5b263aaa5f69892` (`gen_supp.tex`), « identical to the shipped files » ; le contrôle 5 annonce l'identité des graphes de feeders.
- La fiche lie, par `related_identifiers`, un préprint (`10.5281/zenodo.24331675`, `fiche_article_24331675.json`) : son accès est `restricted` et la fiche ne liste aucun fichier. L'article n'est donc pas lisible par le projet : portée *article* impossible.

## Environnement

- sd-92569, podman sans root. Image `replab-lyap` (`Containerfile`, `lance_build.sh`, `build.log`) : base `python:3.11-slim` désignée par l'empreinte `sha256:b701198cb708b68d9413ca67d6311bd97c9389a2c5fe4da0511fc652642366cd` (`image_base.log`), `numpy==2.1.1`, `scipy==1.13.1` (versions de `requirements.txt`, `requirements.log` ; `build.log` relève `numpy 2.1.1 scipy 1.13.1`). `mpmath` et `matplotlib` non installés (figures et test du noyau C hors du périmètre ci-dessus) ; pas de GCC dans l'image. Image archivée : `~/images/zenodo-24331415.tar`, sha256 `711cabb8884904c26fd422cf01ff4982523ca73f43b546e8668ad26461b8ef5a`, identifiant d'image `34f265cd616b16b822edb383b9c1203dc17e8ccf0c941be567571c4ec691598b` (`build.log`).
- Archive manipulée sur l'hôte par `curl`, `md5sum` et `python3 -I` (`zipfile`) seulement ; aucun code du paquet n'a tourné sur l'hôte.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, copie du paquet montée en écriture (`run/`), l'original reste dans `pkg/`.
- Python 3.11.18 dans l'image (`build.log`), la version que le README donne pour les résultats ; la version d'OpenBLAS de l'image n'a pas été relevée. Différences avec le README : scripts lancés par `python3 <script>` depuis `code/` dans le conteneur, comme dans le README ; dossier de travail des feeders `/work/fd` (copie des `.dss`) au lieu de `/tmp/fd`.

## Résultats

Exécution (`lance_run.sh`, `run.log`, code 0, 8 s) :

1. `python3 paper_numbers.py` : code 0 ; « 384 macros written », « closing checks of certified records: 79 failed: [] », « missing: [] ». Une ligne d'avertissement : `WARNING re-verification not passed: cert_mesh_ieee123_mesh_o1` ; elle est émise par `code/paper_numbers.py` (ligne 854, `avertissement.log`) quand le fichier `*.reverify.json` livré pour ce certificat ne satisfait pas son test ; je n'ai pas examiné ce fichier ni ce que l'article en dit (il n'est pas lisible), et je n'en tire rien.
2. `python3 supp_numbers.py` : code 0 ; « 80 macros written », « certified records: 83 », « missing: [] ».
3. `python3 test_ival.py` : code 0 ; « trig enclosure ok », « enclosure violations: 0 ».
4. `python3 tools/feeder_parse.py /work/fd` puis `tools/feeder_mesh.py /work/fd` : codes 0.

Comparaison (`compare.sh`, `bin/compare_json.py`, `compare.log`) :

5. `paper/gen_results.tex` : MD5 livré et régénéré `fcdc7cefe0ecb4006db2972f70b03e32`, `cmp` identique, sha256 `f36a0fe8…735d5` des deux côtés ; `paper/gen_supp.tex` : MD5 `b13be5402c056f03b5b263aaa5f69892` des deux côtés, `cmp` identique. Les sommes concordent avec celles du README.
6. `notes/numbers_provenance.md` et `notes/numbers_provenance_supp.md` : `cmp` identiques.
7. `ieee123_tree.json`, `ieee123_mesh.json`, `ieee8500_tree.json` : `bin/compare_json.py` exact « identique (atol=0.0, rtol=0.0) » et `cmp` identiques. `ieee39_mesh.json` n'est pas produit par ces scripts et n'est pas comparé.
8. `diff -rq` entre le paquet extrait et `run/` (hors `run/fd`) ne signale aucune différence : aucun fichier du paquet n'a été modifié par l'exécution (la commande sort avec le code 1 faute de sortie du `grep -v`, sans différence à lister ; le code 1 de `compare.log` n'a pas d'autre cause).

## Limites

- **Portée paquet.** Le préprint lié est en accès restreint ; rien ici ne dit que les nombres de l'article sont retrouvés. Je n'ai pas non plus vérifié que les macros de `gen_results.tex` correspondent à ce que le texte de l'article cite.
- Les macros sont régénérées à partir des résultats livrés, pas à partir d'une nouvelle exécution des calculs. Ce rapport ne dit rien de la validité des certificats ni de la justesse des résultats de `results/round2/` ; les scripts de nombres vérifient par assertions ce que le README dit, mais je n'ai pas examiné ces assertions.
- Non exécutés : réexécution complète (12,5 h, 64 cœurs, 22 Go de mémoire pour le plus grand cas), contrôle 2 sauf `test_ival.py` (`rigor.py`, `tools/test_tik.py`, `test_sat.py`, `test_trig_kernel.py`, `test_split.py` : GCC absent de l'image), contrôle 3 (ré-vérification d'un certificat), contrôle 4 (synthèse d'un petit certificat), `paper_figures.py`. Rien n'est dit de ces points.
- Une seule exécution de chaque commande ; pas de seconde plate-forme. Le README annonce des essais en Python 3.13 que je n'ai pas refaits.
- Notification : le verdict n'est pas *divergent*, aucune `NOTIFICATION.md`.

## Commandes

Appels exacts en tête de chaque script, depuis la racine du dépôt : `telecharge_extrait.sh` → `telechargement.log` ; lectures : `readme.log`, `requirements.log`, `fiche_zenodo.json`, `fiche_article_24331675.json`, `image_base.log`, `avertissement.log` ; `lance_build.sh` + `Containerfile` → `build.log` ; `lance_run.sh` → `run.log` ; `compare.sh` + `bin/compare_json.py` → `compare.log`.
