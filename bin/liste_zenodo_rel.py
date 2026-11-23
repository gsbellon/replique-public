#!/usr/bin/env python3
"""bin/liste_zenodo_rel.py <fichier capture.sh> : comme liste_zenodo.py, avec les identifiants liés
(relation, identifiant) et la taille. Ne lit que du JSON ; n'exécute rien de tiers."""
import json, sys
txt = open(sys.argv[1], encoding="utf-8").read()
lignes = [l for l in txt.splitlines() if not l.startswith("# ")]
d, _ = json.JSONDecoder().raw_decode("\n".join(lignes))
for h in d["hits"]["hits"]:
    m = h["metadata"]
    fs = h.get("files", [])
    taille = sum(f.get("size", 0) for f in fs)
    rel = ";".join("%s:%s" % (r.get("relation"), r.get("identifier")) for r in m.get("related_identifiers", []))
    print(h["id"], m.get("publication_date"), round(taille / 1e6, 1), "Mo |", m.get("title", "")[:70], "|", rel[:110])
