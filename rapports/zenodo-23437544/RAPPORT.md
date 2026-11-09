# Rapport zenodo-23437544 — état : publiable

Verdict : **inexécutable** — portée : **paquet**. Motif : données non incluses, accès soumis à inscription. Ce verdict est un fait sur le paquet ; il ne dit rien de la science de l'article, dont aucun nombre n'est ni retrouvé ni contesté ici (art. 6, 6 ter). Aucun code du paquet n'a été exécuté.

## Paquet

- Zenodo 23437544, « How Valid Are Reported Android Malware Detection Scores? » (étude de validité sur CICMalDroid2020), téléchargé en `pkg.zip` dans `~/work/z23437544/` sur sd-92569.
- Contenu (`readme_paquet.log`, produit par `bin/capture.sh rapports/zenodo-23437544/readme_paquet.log 'cd ~/work && ls -R z23437544 | head -40; grep -ril "download\|dataset" z23437544 | head'`) : scripts `mal_rq*.py`, `mal_fig*.py`, CSV de résultats (`hasil/`), figures, manuscrit.
- Le listage ci-dessus est tronqué à 40 lignes (`head -40`) ; il ne couvre que le contenu de `naskah/` de façon partielle, sans effet sur ce qui suit.

## Pourquoi le paquet ne peut pas être exécuté

1. Le README du paquet (`readme_reproduce.log`, produit par `bin/capture.sh rapports/zenodo-23437544/readme_reproduce.log 'cat ~/work/z23437544/x/naskah/README_reproduce.txt'`) indique que les scripts attendent `CSV/feature_vectors_syscallsbinders_frequency_5_Cat.csv` (11 598 × 471) et renvoie, pour l'obtenir, à `https://www.unb.ca/cic/datasets/maldroid-2020.html`.
2. Ce fichier n'est pas dans le paquet : `find ~/work/z23437544/x -iname "*feature_vectors*" -o -iname "CSV" -o -size +5M` ne renvoie rien (`recherche_csv.log`, produit par `bin/capture.sh rapports/zenodo-23437544/recherche_csv.log '<cette commande>'`, utilisateur `replab` sur ses propres fichiers, code 0).
3. La page UNB répond HTTP 200 (`acces_donnees.log`) et renvoie vers `http://cicresearch.ca/CICDataset/MalDroid-2020/`. Lue en entier (`liens_donnees4_page_complete.log`, produit par `bin/capture.sh rapports/zenodo-23437544/liens_donnees4_page_complete.log 'curl -sS -L --max-time 30 http://cicresearch.ca/CICDataset/MalDroid-2020/'`), cette page est un formulaire `insert.php` (méthode POST) dont les champs obligatoires sont prénom, nom, courriel, organisation, fonction et pays ; le lien de téléchargement (`browse.php`) n'est ouvert par le script de la page qu'après la réponse positive à ce POST. La page ne contient aucun lien direct vers les fichiers.

Le projet ne remplit aucun formulaire et n'ouvre aucun compte chez un tiers (décision du propriétaire du 2026-10-23, journal). Le formulaire n'a donc ni été rempli ni envoyé : aucune requête POST n'a été faite, seules des requêtes GET.

## Limites

- Le verdict porte sur l'accès aux données à la date des logs (2026-10-22/23). Un lecteur inscrit auprès de l'UNB pourrait obtenir le fichier et exécuter le paquet ; cela n'a pas été fait ici.
- Le README indique que les fichiers `hasil/*.csv` sont les résultats de l'étude ; aucun n'a été régénéré, rien n'est affirmé à leur sujet.
- Aucune notification à l'auteur : le verdict n'est pas *divergent* (art. 6).
