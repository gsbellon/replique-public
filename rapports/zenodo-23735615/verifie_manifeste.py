"""Recalcule le SHA-256 de chaque fichier listé dans manifest.json et compare au manifeste.
Usage : python3 -I verifie_manifeste.py <dossier du run contenant manifest.json>
Les clés du manifeste utilisent « \\ » (Windows) : elles sont lues avec « / ».
Pour un fichier différent, le script teste aussi le hachage du même contenu avec fins de ligne LF -> CRLF
(diagnostic seulement : le fichier compte comme DIFFERENT dans le total).
Ne lit que des fichiers de données ; n'exécute rien du paquet."""
import hashlib
import json
import os
import sys

d = sys.argv[1]
m = json.load(open(os.path.join(d, "manifest.json"), encoding="utf-8"))
files = {k.replace("\\", "/"): v for k, v in m["files"].items()}
ok = bad = absent = bad_crlf_ok = 0
for rel, h in sorted(files.items()):
    p = os.path.join(d, rel)
    if not os.path.isfile(p):
        absent += 1
        print("ABSENT", rel)
        continue
    data = open(p, "rb").read()
    if hashlib.sha256(data).hexdigest() == h:
        ok += 1
        continue
    bad += 1
    crlf = data.replace(b"\r\n", b"\n").replace(b"\n", b"\r\n")
    if hashlib.sha256(crlf).hexdigest() == h:
        bad_crlf_ok += 1
        print("DIFFERENT (concorde avec fins de ligne CRLF)", rel)
    else:
        print("DIFFERENT (aussi en CRLF)", rel)
print("files_count déclaré :", m["files_count"], "| entrées :", len(files))
print("OK", ok, "DIFFERENT", bad, "dont concordant en CRLF", bad_crlf_ok, "ABSENT", absent)
extra = []
for root, _, fs in os.walk(d):
    for f in fs:
        rel = os.path.relpath(os.path.join(root, f), d).replace(os.sep, "/")
        if rel not in files and rel != "manifest.json":
            extra.append(rel)
print("fichiers présents hors manifeste :", len(extra))
for e in sorted(extra)[:20]:
    print("  hors manifeste", e)
