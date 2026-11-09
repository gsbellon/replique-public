# Relecture de zenodo-23864979 — 2026-11-01 (relecteur)

État : reste `brouillon`. Une objection bloquante, un nombre faux.

## Objection (bloquante)

Résultat 3 (B — atlas) : le rapport écrit « **28 cas** de surplus du consommateur neutre au premier ordre ». `run.log` en liste **26** (lignes 47 à 84, de G17 à G1251). Vérifié : `grep -c "^('G" rapports/zenodo-23864979/run.log` → 26 (outil Grep, mode count). `run2.log` ne diffère que par les horodatages, donc même compte.

Je ne corrige pas un nombre (consigne de relecture). L'auteur doit remplacer 28 par 26, ou, s'il a une autre source pour 28, nommer la commande qui le produit. Le script B n'imprime pas lui-même de total de ces cas ; le compte est fait sur la liste : le dire et donner la commande de comptage (ex. `grep -c` via `bin/capture.sh`), puisque chaque nombre doit être accompagné de sa commande.

## Vérifié et conforme

- Versions (build.log) : Python 3.12.15, sympy 1.14.0, numpy 2.5.4, scipy 1.18.1, networkx 3.7, matplotlib 3.11.2.
- Durées A 7, B 2, C 1, D 6, E 5, F 2 s, total 24 s ; codes 0.
- Étude B : 980 graphes. C : spectre, `w`, `w − Rw` constant True, `w + Rw` constant False. D : 12 000 tirages, 3297/8703/2447/11, quatorze compteurs à 0, TOTAL 0.
- E : tous les comptes (154/154 … 239/240, échecs 0/0/0/5), min W 63,28098 en t = 3,020, W(0) = 70,43787.
- F : a, b, 1,311 %, n = 7, [2,2,4,4,4,4,4], 980/14, `False` pour P₅.
- Répétabilité : `diff run.log run2.log` ne montre que horodatages, heures de fichiers, durée 24/23.
- Verdict *reproduit* / portée *paquet* au sens faible : justifié et la limite (aucune sortie livrée) est énoncée honnêtement ; je ne la juge pas inacceptable. Pas d'intention prêtée, pas de « fraude » ni synonyme.

## Après correction

Une fois le nombre corrigé (ou sourcé), le rapport sera publiable ; le reste est conforme.
