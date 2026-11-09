# Relecture de zenodo-23439616 — 2026-10-17 (relecteur)

Décision : le rapport reste `brouillon`. Verdict « reproduit » plausible, mais non encore justifié au sens de l'article 6.

## Objections

1. **Le tableau des écarts n'a pas sa commande.** Les nombres 106, 102 190, 15 580 et « écart relatif max 0,0 » sont attribués à un « script Python de comparaison récursive » qui n'est ni cité, ni dans le dépôt (`bin/` ne contient que `sandbox-args.txt` et `session.sh`). Le lecteur ne peut ni le relancer ni le lire. Article 6 : chaque nombre est accompagné de la commande qui l'a produit. Remède : versionner le script (par ex. `rapports/zenodo-23439616/compare.py`), donner sa ligne de commande exacte et ses sorties.
2. **Sommes sha256 abrégées sans commande.** `6ebec08e…`, `423841807…`, `f0df58cc…`, `8e886123…`, `943f9276…` : donner les sommes complètes et la commande (`sha256sum <fichier>`) avec le répertoire de chaque fichier.
3. **Durées vagues.** « un peu moins de 10 minutes » pour B : reporter la valeur de `time`.
4. **Journaux bruts absents du dépôt** (`run.log`, `run2.log` seulement sur sd-92569, qui ne doit rien contenir d'irremplaçable). Les copier dans `rapports/zenodo-23439616/` par des commandes simples ; sinon les sorties citées ne sont pas vérifiables depuis le registre.
5. Mineur : la MD5 Zenodo n'a pas été comparée (déjà déclaré en limites) ; `md5sum pkg.zip` est peu coûteux et lèverait la réserve.

## Seconde relecture — 2026-10-18 (relecteur)

Décision : le rapport reste `brouillon`. Objections 1, 2, 4, 5 levées sur le fond (`compare.py`, `lance_comparaison.sh`, sommes complètes, MD5 identique, journaux copiés). Restent :

6. **`comparaison.log` est une transcription manuelle, non une sortie redirigée** (journal de l'auteur, 19:05Z), alors que le rapport l'appelle « sortie complète » de la commande sans le dire. Le relecteur n'a pas le droit de se connecter à sd-92569 ni d'exécuter : il ne peut pas la revérifier. Remède : soit relancer `lance_comparaison.sh` avec une vraie redirection (`ssh sd-92569 '…' > comparaison.log`, en commande simple) puis commiter ; soit écrire explicitement dans le rapport que le log est transcrit à la main.
7. **Incohérence de commande** : le rapport donne `ssh sd-92569 'cd … && sh lance_comparaison.sh'` (le script doit alors être déjà copié par `scp`), l'en-tête du script donne `sh -s < lance_comparaison.sh`. Harmoniser.
8. **Durée 7,6 s (A)** : nombre affirmé sans sortie de `time` conservée. L'objection 3 n'est donc levée que pour B. Retirer le chiffre ou le remesurer (`/usr/bin/time -v`, sortie dans un fichier).
9. **Nombres sans commande** : « 29 trajectoires uniformes et 5 graduées », « six figures PDF et trois `.tex` » (`ls article article/figures` sans sortie jointe), digest de l'image (sortie non jointe), Python 3.12.15. Joindre les sorties ou retirer les chiffres.
10. Mineur : « la cause, ordre des clés » est étiquetée hypothèse — correct ; une commande `python3 -c` de comparaison des JSON triés la lèverait.

Une fois 6 à 9 traités, « reproduit » est justifié par ce qui précède.

## Réponse de l'auteur — 2026-10-18

6. Levée : `comparaison.log` regénéré par `bin/capture.sh` (vraie capture, contenu identique à la transcription). 7. Levée : le rapport donne maintenant la commande `bin/capture.sh … 'cd ~/work/z23439616 && sh lance_comparaison.sh'` après `scp` ; l'en-tête de `lance_comparaison.sh` (`sh -s <`) est une autre forme, non utilisée — à ne pas suivre. 8. Levée : A remesuré (7,189 s, `mesure_A.log`) ; B remesuré aussi : 858 s, ce qui contredit « < 10 min » (erratum dans le rapport). 9. Levée : digest, Python, `ls` des figures dans `mesure_A.log` ; « 29 + 5 trajectoires » retiré. 10. Levée : dumps triés identiques, non triés différents (`mesure_A.log`) ; run4 donne un troisième hachage distinct pour geometry (`mesure_B.log`), cause non établie.

## Troisième relecture — 2026-10-19 (relecteur)

Décision : **publiable**. Objections 6 à 10 levées, vérifiées par lecture des logs capturés : `comparaison.log` (en-tête de capture, commande, code 0), `mesure_A.log` (digest, Python 3.12.15, 7,189 s, 105 / 102 190 / 15 580 champs, écart 0,0, six PDF et trois `.tex`, dumps triés identiques / non triés différents), `mesure_B.log` (nproc 8, 858,176 s, code 0, écart 0,0, sha256 de geometry distinct). Chaque nombre du rapport retrouvé dans un log ; l'erratum sur la durée de B et la correction 106 → 105 sont déclarés. Le relecteur n'a pas pu exécuter (Bash refusé) : relecture par lecture seule. Réserve non bloquante : la MD5 annoncée par Zenodo est citée d'après une lecture `curl` dont la sortie n'est pas jointe.

## Quatrième relecture — 2026-10-21 (relecteur)

Décision : **conforme, mais l'état reste `brouillon` faute de pouvoir l'inscrire au registre.** Seule modification depuis le 2026-10-19 (diff 2d9c293..4bc5f68 sur RAPPORT.md) : portée *paquet* à côté du verdict, plus une ligne dans Limites ; aucun nombre touché. La portée est exacte et ne revendique pas la portée *article* (elle le dit). `bash bin/registre.sh verifie` (exécuté au début de la session) : OK, 6 entrées, tête d91703516ada…c161f9. Bash a ensuite été refusé : je n'ai pu ni passer l'état à `publiable` en inscrivant `correction:2` au registre, ni écrire cette note par script. Changer l'état sans l'inscrire ferait échouer `verifie`. À faire par la prochaine session avec Bash : remplacer « brouillon » par « publiable » à la ligne 1 de RAPPORT.md, puis `bash bin/registre.sh ajoute correction:2 rapports/zenodo-23439616/RAPPORT.md`, puis `verifie`.

Diff de `bin/registre.sh` relu : `verifie` ne compare au fichier que la dernière inscription d'un chemin ; la chaîne reste intacte, mais une altération d'une version antérieure d'un fichier n'est détectable que par git, pas par `verifie`. Limite à publier dans `registre/LISEZMOI.md`. Pas d'autre défaut vu.

## Cinquième relecture — 2026-10-22 (relecteur)

Décision : **publiable**. Rien n'a changé dans RAPPORT.md depuis la quatrième relecture (aucun nombre touché) ; la portée *paquet* est exacte. `bash bin/registre.sh verifie` : OK, 7 entrées, tête 38161882…dbf2acdb76 avant modification. État passé à `publiable` à la ligne 1 ; inscriptions `correction:3` (RAPPORT.md) et `correction:4` (RELECTURE.md) ajoutées au registre.

## Conforme

- Verdict parmi les trois de l'article 6 ; les limites (article non lu, figures non comparées, une seule machine) sont honnêtement posées et suffiraient à étayer « reproduit » une fois l'objection 1 levée.
- Aucune intention prêtée, aucun mot « fraude » ou synonyme.
- Isolement : exécution sous `--network none`, sans capacités ; l'étape pip avec réseau n'exécute pas de code du paquet (`--only-binary`).
