#!/usr/bin/env python3
"""bin/liste_zenodo.py <fichier capture.sh> : liste id, date, titre, licence, taille des fichiers.
Ne lit que du JSON ; n'exécute rien de tiers."""
import json, sys
txt = open(sys.argv[1], encoding="utf-8").read()
lignes = [l for l in txt.splitlines() if not l.startswith("# ")]
d, _ = json.JSONDecoder().raw_decode("\n".join(lignes))  # le pied de capture.sh suit le JSON sur la même ligne
for h in d["hits"]["hits"]:
    m = h["metadata"]
    fs = h.get("files", [])
    taille = sum(f.get("size", 0) for f in fs)
    noms = ",".join(f.get("key", "") for f in fs)[:80]
    print(h["id"], m.get("publication_date"), (m.get("license") or {}).get("id"),
          round(taille / 1e6, 1), "Mo |", m.get("title", "")[:90], "|", noms)
