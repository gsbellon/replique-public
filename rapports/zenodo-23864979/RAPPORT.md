# Rapport zenodo-23864979 — état : publiable

Verdict proposé : **reproduit** — portée : **paquet**, au sens faible précisé ci-dessous. Les six scripts du paquet (A à F) s'exécutent jusqu'au bout dans un conteneur sans réseau, code 0 chacun, en 24 s au total ; les vérifications que les scripts font d'eux-mêmes passent (`TOTAL VIOLATIONS: 0` sur 12 000 tirages, tous les « True » des scripts A à C) ; une seconde exécution donne exactement la même sortie, aux horodatages près (`run.log`, `run2.log`). **Le paquet ne livre aucun fichier de résultat** (ni sortie attendue, ni figure) : il n'y a donc rien à comparer octet à octet, et ce rapport ne compare ni à l'article (non lu, art. 6 ter) ni à une sortie livrée. Ce que « reproduit / paquet » affirme ici : le code livré tourne, est déterministe, et ses propres contrôles réussissent. Deux comptes de l'étude E ne sont pas unanimes (246/247 et 239/240) ; je ne sais pas si l'article les annonce ainsi (Limites).

Couverture : *exécution seule* (le paquet ne livre aucune sortie à comparer).

## Paquet

- Zenodo 23864979, « Replication package for "Cost dispersion in networked Cournot oligopoly: neutrality and welfare hold if and only if the graph is regular" », publié le 2026-11-01, un auteur (King Saud University), type logiciel, accès ouvert, licence CC-BY-4.0 (README : code sous MIT). Fiche : `bin/capture.sh rapports/zenodo-23864979/fiche_zenodo.json 'curl -sS -f -m 60 https://zenodo.org/api/records/23864979'`.
- Un fichier, `cost_dispersion_networks_replication_v4.0.zip`, 13 789 octets (fiche) ; MD5 de la fiche concordant avec le fichier téléchargé (`telechargement.log`, ligne « OK ») ; 8 fichiers extraits (même fichier), code d'extraction 0 : six scripts `A_` à `F_`, `README.md`, `LICENSE`.
- Données : aucune ; le README dit « No empirical data are used: all inputs are generated inside the scripts » (`readme.log`). Art. 1 : dans le périmètre (logiciels libres uniquement).
- Dépendances : README « Python 3.10 or later » avec `sympy numpy scipy networkx matplotlib`, sans versions, sans fichier de requirements.

## Environnement

- sd-92569, podman sans root. Image construite par `Containerfile` / `lance_build.sh` à partir de `python:3.12-slim` avec `pip install sympy numpy scipy networkx matplotlib` (réseau seulement pendant la construction, code 0). Versions résolues le 2026-11-01 (`build.log`) : Python 3.12.15, sympy 1.14.0, numpy 2.5.4, scipy 1.18.1, networkx 3.7, matplotlib 3.11.2. Les versions utilisées par l'auteur ne sont pas connues.
- Archive manipulée sur l'hôte uniquement par `curl`, `md5sum`, `python3 -I` (`zipfile.extractall`) ; aucun code du paquet n'a tourné sur l'hôte.
- Politique de sortie de l'hôte en place (relevée après les exécutions, `sudo nft list table inet replab` et `sudo nft list chain ip filter ufw-user-output`, `politique_sortie.log`) : ports 25, 465, 587 refusés ; destinations journalisées pour l'utilisateur 1001 à 20 nouvelles connexions par seconde. Même règle relevée en entier plus tôt dans la journée (`rapports/zenodo-23804087/politique_sortie.log`).
- Exécution : `--network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp`, seul `run/` (copie du paquet) monté en écriture ; l'original reste intact dans `pkg/` (`lance_run.sh`). Aucun réseau pendant l'exécution, aucun secret à bord.

## Résultats

Tout provient de `run.log` (appel : `lance_run.sh`) ; `run2.log` est une seconde exécution identique.

1. **Exécution.** Les six scripts : code 0. Durées : A 7 s, B 2 s, C 1 s, D 6 s, E 5 s, F 2 s ; ensemble 24 s.
2. **A — formes closes (sympy).** Toutes les vérifications affichées valent `True` ou `0` : conditions du premier ordre, `Q = w'u`, `(I+γA)R = I−R`, `Π = b q'q`, `CS = (b/2) q'(I+γA)q`, écarts nuls entre dérivées et valeurs prédites, `W'' − (1/b) d'R(3I+γA)Rd = 0` ; sur `K_n`, n = 2 à 6, `w` et `Rw` ont toutes leurs entrées égales (`True` à chaque ligne).
3. **B — atlas.** `K_n`, n = 2 à 6 : `True`. Recherche exhaustive : 980 graphes connexes non réguliers de n ≤ 7 examinés ; 26 cas de surplus du consommateur neutre au premier ordre, tous dans la région admissible (colonne `interior w>0` : `True`). La liste complète est dans `run.log` ; le script B n'imprime pas de total, le compte est fait sur cette liste : `bash bin/compte_lignes.sh rapports/zenodo-23864979/run.log "^('G" rapports/zenodo-23864979/compte_cas.log` → 26 (`compte_cas.log`). Correction du « 28 » du brouillon initial, relevée par le relecteur (`RELECTURE.md`).
4. **C — roue W₄, γ = 1/2.** Spectre {−2, 1−√5, 1+√5, 0 (×2)} ; γ·λ_min = −1 ≥ −1 : `True` ; `w = [1/5, 3/10, 3/10, 3/10, 3/10]` ; `w − Rw` constant : `True` ; `w + Rw` constant : `False` (affiché tel quel).
5. **D — 12 000 tirages aléatoires** (graine fixée selon le README). `DRAW COUNTS: draws 12000, regular 3297, nonregular 8703, Kn 2447, A4_resamples 11`. Quatorze compteurs de violations, tous à 0 ; `TOTAL VIOLATIONS: 0`.
6. **E — courbure et figures.** Pour E ∈ {0 ; 0,5 ; 1 ; 2} : graphes réguliers avec W′(0)=0 : 154/154, 153/153, 159/159, 155/155 ; direction d* abaisse W : 246/246, 247/247, 241/241, 240/240 ; **signe de W′(0) en accord avec la règle linéaire : 246/246, 246/247, 241/241, 239/240** — deux cas en désaccord (E=0,5 et E=2) ; échecs du solveur ignorés : 0, 0, 0, 5 (E=2). Dépassement de la frontière A4 sur K₁,₃ : minimum de W 63,28098 en t = 3,020, W(0) = 70,43787. Écrit : `fig1_welfare_paths.{pdf,png,svg}`, `fig2_star_centrality.{pdf,png,svg}`, `star_W_path.npy` (liste `ls -l` de fin de `run.log`).
7. **F — transferts.** Corollaires 8 à 10 sur K₁,₃, W₄, K₄, P₅ ; identités exactes (`w+Rw = a·1 + b·w`, a = −4/13, b = 29/13 sur l'étoile ; a = −1/5, b = 2 sur la roue) ; « same direction as Corollary 8? » : `True`, `True`, `False` (P₅). Comparaison exhaustive des deux règles : 980 graphes non réguliers de n ≤ 7, 14 réguliers écartés, écart maximal 1,311 % (n = 7, degrés [2, 2, 4, 4, 4, 4, 4], γ = 0,5).
8. **Répétabilité.** `diff rapports/zenodo-23864979/run.log rapports/zenodo-23864979/run2.log` : seules les lignes d'horodatage, les heures de fichiers et la durée totale (24 s / 23 s) diffèrent ; tous les nombres sont identiques.

## Limites

- **Aucune sortie livrée** : le paquet n'a pas de fichier de résultat à régénérer. La portée *paquet* de l'art. 6 ter (« les fichiers de résultats fournis … sont régénérés ») n'est donc remplie qu'au sens faible indiqué plus haut. Je propose *reproduit* parce que rien n'est divergent ni inexécutable, mais le relecteur peut juger que la portée ne s'applique pas et le dire ; voir `journal/AMENDEMENTS.md`.
- **Article non lu.** Je ne sais pas si l'article annonce les comptes de l'étude E (246/247, 239/240, 5 échecs du solveur, `False` pour P₅, `w+Rw` non constant sur la roue) ni les mêmes valeurs numériques. Les `False` et les comptes non unanimes sont rapportés tels quels, sans interprétation. Rien n'est dit de la validité des preuves.
- Les contrôles de A à D sont ceux que les scripts écrivent pour eux-mêmes ; je n'ai pas relu leur code pour juger si les tests sont suffisants.
- Les versions des bibliothèques sont les plus récentes à la date de construction ; l'auteur n'en donne pas. Les résultats pourraient varier avec d'autres versions (non essayé).
- Les figures ont été produites mais pas comparées à celles de l'article.

## Commandes

```
bin/capture.sh rapports/zenodo-23864979/fiche_zenodo.json 'curl -sS -f -m 60 https://zenodo.org/api/records/23864979'
scp rapports/zenodo-23864979/telecharge_extrait.sh sd-92569:work/
bin/capture.sh rapports/zenodo-23864979/telechargement.log 'sh work/telecharge_extrait.sh'
bin/capture.sh rapports/zenodo-23864979/readme.log 'cat work/z23864979/pkg/cost_dispersion_networks_replication_v4.0/README.md'
bin/capture.sh rapports/zenodo-23864979/images.log 'podman images'
scp rapports/zenodo-23864979/lance_build.sh rapports/zenodo-23864979/Containerfile sd-92569:work/z23864979/
bin/capture.sh rapports/zenodo-23864979/build.log 'cd ~/work/z23864979 && sh lance_build.sh'
scp rapports/zenodo-23864979/lance_run.sh sd-92569:work/z23864979/
bin/capture.sh rapports/zenodo-23864979/run.log 'cd ~/work/z23864979 && sh lance_run.sh'
bin/capture.sh rapports/zenodo-23864979/run2.log 'cd ~/work/z23864979 && sh lance_run.sh'
diff rapports/zenodo-23864979/run.log rapports/zenodo-23864979/run2.log
bin/capture.sh rapports/zenodo-23864979/politique_sortie.log 'sudo nft list table inet replab; sudo nft list chain ip filter ufw-user-output'
```

Recherche d'origine : `bin/capture.sh rapports/zenodo-recherche-20261101/recherche.json 'curl -s -m 60 "https://zenodo.org/api/records?q=%22replication+package%22+AND+access_right:open&sort=mostrecent&size=25&page=1&type=software"'`, puis `bash bin/liste_zenodo.sh rapports/zenodo-recherche-20261101/recherche.json`. Choix du paquet : petit, sans donnée, ouvert, Python ; non fondé sur l'auteur (art. 6 bis : l'auteur n'est pas dans la liste).

Chaque nombre ci-dessus provient du fichier nommé à côté de lui. Les fichiers `.log` ont tous été produits par `bin/capture.sh` ; `images.log` est cité pour l'état des images avant la construction.
