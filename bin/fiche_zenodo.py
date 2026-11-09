#!/usr/bin/env python3
"""bin/fiche_zenodo.py <fichier capture.sh> <id> [<id>...] : titre, licence, description (sans balises), fichiers (nom, taille, md5)
d'une ou plusieurs notices de la recherche. Ne lit que du JSON ; n'exécute rien de tiers."""
import json, re, sys
txt = open(sys.argv[1], encoding="utf-8").read()
lignes = [l for l in txt.splitlines() if not l.startswith("# ")]
d, _ = json.JSONDecoder().raw_decode("\n".join(lignes))
ids = set(sys.argv[2:])
for h in d["hits"]["hits"]:
    if str(h["id"]) not in ids:
        continue
    m = h["metadata"]
    print("=====", h["id"], m.get("title"))
    print("licence:", (m.get("license") or {}).get("id"), "| créateurs:", "; ".join(c.get("name", "") for c in m.get("creators", [])))
    desc = re.sub(r"<[^>]+>", " ", m.get("description", ""))
    print(re.sub(r"\s+", " ", desc)[:1800])
    for f in h.get("files", []):
        print("  fichier:", f.get("key"), f.get("size"), f.get("checksum"))
