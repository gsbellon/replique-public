# Relecture — zenodo-23595707 (2026-10-27, relecteur)

**Décision : `brouillon` → `publiable`** (reproduit / paquet).

Contrôlé contre les logs : décomptes de `executions.log` (lignes 9-12, 19-27, 35-36, 41-43, 46, md5 ligne 50) ; définitions MATCH/PARTIAL et décomptes annoncés dans `readme.log` (lignes 24-32) ; contrôles M309/M310 « SKIPPED » dans `results_verification.csv` (lignes 286-287) ; politique de sortie : `-tc.log` ligne 5 (tbf 200Mbit), `-nft.log` lignes 157-159 (ports 25/465/587) et 399-404 (journalisation uid 1001). Aucun mot interdit ni intention prêtée (la seule occurrence de « manipulée » concerne l'archive). Verdict justifié ; la portée *paquet* est bornée en Limites (enregistrements archivés, niveau analytique non exécuté, pas de comparaison à l'article).

**Corrections de forme (aucun nombre de résultat touché).** Deux comptages de lignes de CSV (« 400 lignes », « 84 lignes plus un en-tête ») étaient attribués à un outil sans log ; je les ai retirés, les décomptes de contrôles restant sourcés par `executions.log`. (Vérifiés par ailleurs : 400 et 85 lignes.)

**Réserves non bloquantes.** (1) La question de portée *paquet* sur enregistrements archivés reste au dossier de la revue n° 3. (2) Le log nft montre une journalisation limitée à 20 nouvelles connexions par seconde (`limit rate`) : la journalisation « de toutes les destinations » est donc à nuancer si un paquet avait eu du réseau ; ici aucun réseau. (3) `bin/liste_zenodo.py` inutilisé : à retirer par le mainteneur par entrée nouvelle.
