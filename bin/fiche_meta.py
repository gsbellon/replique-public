#!/usr/bin/env python3
"""bin/fiche_meta.py <notice.json> : titre, créateurs (nom, affiliation, ORCID), identifiants liés, type, début de description
d'une notice Zenodo capturée (en-têtes de capture.sh admis). Ne lit que du JSON ; n'exécute rien de tiers.
Appel : python3 -I bin/fiche_meta.py rapports/zenodo-<id>/fiche_zenodo.json"""
import json, re, sys
txt = open(sys.argv[1], encoding="utf-8").read()
lignes = [l for l in txt.splitlines() if not l.startswith("# ")]
d, _ = json.JSONDecoder().raw_decode("\n".join(lignes))
m = d["metadata"]
print("titre:", m.get("title"))
for c in m.get("creators", []):
    print("créateur:", c.get("name"), "|", c.get("affiliation"), "|", c.get("orcid"))
print("liés:", json.dumps(m.get("related_identifiers"), ensure_ascii=False))
print("type:", (m.get("resource_type") or {}).get("title"), "| publication:", m.get("publication_date"))
desc = re.sub(r"<[^>]+>", " ", m.get("description", ""))
print("description:", re.sub(r"\s+", " ", desc)[:700])
