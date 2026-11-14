# Rapport zenodo-24218418 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**, **partielle** (à lire avec la ligne « Couverture »). Le README ne documente aucune commande. Les quatre scripts de `code/` qui ne lisent que `resultados/` (`cifras_manuscrito.py`, `extras_manuscrito.py`, `sensibilidad_paso.py`, `figura1.py`) s'exécutent jusqu'au bout, code 0, dans un conteneur sans réseau (`run.log`). Les sept fichiers de `resultados/` qu'ils réécrivent (4 CSV, 3 JSON) sont régénérés : après suppression du seul CR de fin de ligne (les fichiers livrés sont en CRLF, les régénérés en LF), les sept sont identiques à l'octet à ceux livrés (`compare.log`, `compare_crlf.log`) ; les quatre CSV sont de plus identiques au comparateur commun, à tolérance nulle (`compare.log`). Les quatre autres fichiers de `resultados/` (`comentarios_todos.csv`, `resumen_conversaciones.csv`, `replicacion_filas.csv`, `ablacion.json`), qui sont les entrées de ces scripts, **ne sont pas régénérés** : ils proviennent des données brutes Pol.is, non redistribuées, que je n'ai pas téléchargées. Le rapport ne dit rien de la chaîne qui va des données brutes à ces quatre fichiers, ni des nombres du manuscrit, qui n'a pas été lu (art. 6 ter).

Couverture : *régénération*, partielle : 7 des 11 fichiers de résultats livrés sont régénérés et comparés ; 4 ne le sont pas (voir ci-dessus et Limites).

## Paquet

- Zenodo 24218418, « Replication package for "Auditing consensus in Pol.is: Partial identification of group agreement when participants pass" », publié le 2026-11-14, un auteur (Universidad Bolivariana del Ecuador), type logiciel, accès ouvert, CC BY 4.0 (code sous MIT selon le README). Fiche : `bin/capture.sh rapports/zenodo-24218418/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/24218418'`.
- Un fichier, `polis_replication_v1.zip`, 1 422 280 octets ; MD5 de la fiche concordant avec le fichier téléchargé (`telechargement.log`, ligne « OK ») ; 24 fichiers extraits, code d'extraction 0 : 11 fichiers dans `resultados/`, 12 scripts Python dans `code/`, `README.md` (`telechargement.log`, `readme.log`).
- Données : les données brutes sont celles de https://github.com/compdemocracy/openData (accès public direct, CC BY 4.0 selon le README) ; elles ne sont pas incluses, et le README ne désigne ni version ni commit. Art. 1 : dans le périmètre (données en accès public direct) ; le paquet livre des sorties de référence.
- Dépendances : aucune version annoncée ni `requirements.txt`.

## Environnement

- sd-92569, podman sans root. Image `replab-polis` construite par `Containerfile` / `lance_build.sh` : base `python:3.13-slim` désignée par l'empreinte `sha256:48d884813cf4…` (celle de zenodo-24141273), versions exactes numpy 2.5.3, pandas 3.0.5, scipy 1.18.1, matplotlib 3.11.2 ; versions résolues relevées par `pip freeze` dans `build.log` (Python 3.13.18). Réseau seulement pendant la construction (code 0). Image archivée : `~/images/zenodo-24218418.tar`, sha256 `b45d1e9d44eff2c93092fe7662fe60542fbfb1f1e41d8b8e49970c54b6db912f`, identifiant d'image `35c0a2803ce1…` (`build.log`). Les versions de l'auteur ne sont pas connues.
- Archive manipulée sur l'hôte uniquement par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) ; aucun code du paquet n'a tourné sur l'hôte.
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seule une copie du paquet (`run/`) montée en écriture ; l'original reste dans `pkg/`.

## Résultats

1. **Commandes retenues** (`lance_run.sh`) : `python3 code/<script>.py resultados` dans l'ordre `cifras_manuscrito`, `extras_manuscrito`, `sensibilidad_paso`, puis `python3 code/figura1.py resultados figuras`. Ce choix est le mien : le README ne donne pas de commande ; l'ordre suit les fichiers lus et écrits par ces scripts (`cifras_manuscrito.py` écrit `consensos_polis_tipados.csv`, lu ensuite par les deux autres).
2. **Exécution** (`run.log`) : code 0 aux quatre étapes ; durées 2 s, 3 s, 4 s (`figura1.py` : `ok 17`, un avertissement de dépréciation pandas). Fichiers modifiés par rapport au paquet livré : sept dans `resultados/` plus le dossier `figuras/` créé (fin de `run.log`).
3. **Comparaison brute** (`compare.sh`, `compare.log`) : les quatre CSV sont identiques selon `bin/compare_csv.py` à tolérance nulle et à rtol 1e-9 ; les trois JSON diffèrent à l'octet « à l'octet 2, ligne 1 » ; le décompte des CR (`compare.log`, dernière section) montre 170, 163 et 25 CR dans les JSON livrés (autant que de lignes) et 0 dans les régénérés.
4. **Comparaison après suppression du CR de fin de ligne** (`compare_crlf.sh`, `compare_crlf.log`) : les sept fichiers sont identiques à l'octet (1 305 ; 473 984 ; 54 405 ; 736 ; 2 776 ; 4 364 ; 541 octets). Aucune valeur numérique ne diffère.
5. **Valeurs lues dans `cifras.json` livré** (aperçu de `compare.log`, non réinterprétées) : 19 conversations, 25 884 participants, 6 411 commentaires, 1 051 consensus Pol.is dont 485 certifiés ; elles sont retrouvées à l'identique dans le fichier régénéré (point 4).

## Limites

- **Régénération partielle.** Non exécutés : `corpus_polis.py`, `replicacion_polis.py`, `ablacion_polis.py` (donnent `comentarios_todos.csv`, `resumen_conversaciones.csv`, `replicacion_filas.csv`, `ablacion.json`, à partir de `participants-votes.csv`, `comments.csv` et, pour `soic_polis.py`, `pca2.json` et `comments.json` de chaque conversation), `soic_polis.py`, `build_manuscript.py`, `refs_apa.py`, `omml_eq.py`. Cause : les données brutes ne sont pas dans l'archive, le README n'en désigne pas de version ; je ne les ai pas téléchargées cette nuit. Ces quatre fichiers sont donc pris tels que livrés et servent d'entrée. Un verdict pour la chaîne complète reste à établir.
- **Commandes non documentées.** Le choix des commandes et de leur ordre est le mien (Résultats 1) ; je n'ai pas vérifié que c'est celui de l'auteur.
- **Figure** : `figuras/Fig1.png` et `Fig1.tiff` sont produites mais le paquet ne livre aucune figure à laquelle les comparer ; elles ne sont pas évaluées.
- **Fins de ligne** : l'identité est établie après suppression du CR de fin de ligne ; les fichiers livrés ne sont pas identiques à l'octet tels que livrés.
- Versions de bibliothèques choisies par moi ; pas essayé avec d'autres. Pas de seconde exécution.
- Les nombres du manuscrit ne sont pas comparés (non lu).

## Commandes

```
bin/capture.sh rapports/zenodo-recherche-20261114/recherche.json 'curl -s -m 60 "https://zenodo.org/api/records?q=%22replication+package%22+AND+access_right:open&sort=mostrecent&size=25&page=1&type=software"'
bash bin/liste_zenodo.sh rapports/zenodo-recherche-20261114/recherche.json
bin/capture.sh rapports/zenodo-24218418/fiche_zenodo.json 'curl -sS -m 60 https://zenodo.org/api/records/24218418'
scp rapports/zenodo-24218418/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-24218418/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-24218418/readme.log 'cat work/z24218418/pkg/README.md'
bin/capture.sh rapports/zenodo-24218418/code_grep.log 'grep -n -E "http|openData|git |requests|urllib|argv|open\(|read_csv|DATA|path|Path" work/z24218418/pkg/code/corpus_polis.py work/z24218418/pkg/code/soic_polis.py work/z24218418/pkg/code/replicacion_polis.py work/z24218418/pkg/code/cifras_manuscrito.py'
bin/capture.sh rapports/zenodo-24218418/scripts_cat.log 'cat work/z24218418/pkg/code/cifras_manuscrito.py work/z24218418/pkg/code/extras_manuscrito.py work/z24218418/pkg/code/figura1.py work/z24218418/pkg/code/sensibilidad_paso.py'
scp rapports/zenodo-24218418/lance_build.sh rapports/zenodo-24218418/Containerfile rapports/zenodo-24218418/lance_run.sh sd-92569:work/z24218418/
bin/capture.sh rapports/zenodo-24218418/build.log 'cd ~/work/z24218418 && sh lance_build.sh'
bin/capture.sh rapports/zenodo-24218418/run.log 'cd ~/work/z24218418 && sh lance_run.sh'
scp rapports/zenodo-24218418/compare.sh bin/compare_csv.py sd-92569:work/z24218418/
bin/capture.sh rapports/zenodo-24218418/compare.log 'cd ~/work/z24218418 && sh compare.sh'
scp rapports/zenodo-24218418/compare_crlf.sh sd-92569:work/z24218418/
bin/capture.sh rapports/zenodo-24218418/compare_crlf.log 'cd ~/work/z24218418 && sh compare_crlf.sh'
```

Choix du paquet : petit, Python, sorties livrées, données dérivées incluses, ouvert ; non fondé sur l'auteur (art. 6 bis : l'auteur n'est pas dans la liste). Chaque nombre ci-dessus provient du fichier nommé à côté de lui. Tous les `.log` ont été produits par `bin/capture.sh`.
