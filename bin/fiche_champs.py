#!/usr/bin/env python3
"""bin/fiche_champs.py <fiche_zenodo.json produit par capture.sh> : titre, créateurs (nom, affiliation, ORCID),
identifiants liés, licence et description (sans balises, 1200 caractères) d'une notice Zenodo, pour écrire FICHE.md.
Ne lit que du JSON ; n'exécute rien de tiers ; ne fait aucune recherche sur les personnes."""
import json, re, sys
txt = open(sys.argv[1], encoding="utf-8").read()
lignes = [l for l in txt.splitlines() if not l.startswith("# ")]
d, _ = json.JSONDecoder().raw_decode("\n".join(lignes))
m = d["metadata"]
print("id:", d.get("id"), "| doi:", d.get("doi"))
print("titre:", m.get("title"))
for c in m.get("creators", []):
    print("créateur:", c.get("name"), "|", c.get("affiliation"), "|", c.get("orcid"))
print("identifiants liés:", m.get("related_identifiers"))
print("licence:", (m.get("license") or {}).get("id"), "| type:", (m.get("resource_type") or {}).get("type"))
desc = re.sub(r"<[^>]+>", " ", m.get("description", ""))
print("description:", re.sub(r"\s+", " ", desc)[:1200])
