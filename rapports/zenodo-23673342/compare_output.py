"""Ligne d'appel (sur sd-92569, depuis ~/work/z23673342) :
    python3 -I compare_output.py pkg/output run_full/output
    python3 -I compare_output.py pkg/output run_agg2/output
(lancée par lance_compare.sh ; sortie conservée par bin/capture.sh -> comparaison_*.log)
Parcourt récursivement le dossier output/ fourni (A) et celui régénéré (B). Pour chaque fichier : absent de B,
identique à l'octet, ou différent. Pour les CSV différents : comparaison cellule par cellule (numérique : écart relatif
|a-b| / max(|a|,|b|) ; texte : égalité stricte) et, si seul le codage des fins de ligne diffère, mention CRLF.
Ne lit que des fichiers ; modules csv, hashlib, os de la bibliothèque standard."""
import csv, hashlib, os, sys

A, B = sys.argv[1], sys.argv[2]
SEUILS = [0.0, 1e-12, 1e-9, 1e-6, 1e-3]


def sha(p):
    return hashlib.sha256(open(p, "rb").read()).hexdigest()


def num(s):
    try:
        return float(s)
    except ValueError:
        return None


def lire(p):
    return list(csv.reader(open(p, newline="", encoding="utf-8")))


fichiers = sorted(os.path.relpath(os.path.join(d, f), A) for d, _, fs in os.walk(A) for f in fs)
n_id = n_diff = n_abs = 0
extra = sorted(os.path.relpath(os.path.join(d, f), B) for d, _, fs in os.walk(B) for f in fs)
for rel in fichiers:
    pa, pb = os.path.join(A, rel), os.path.join(B, rel)
    if not os.path.exists(pb):
        print(f"ABSENT de B : {rel}")
        n_abs += 1
        continue
    if sha(pa) == sha(pb):
        print(f"IDENTIQUE   : {rel}")
        n_id += 1
        continue
    n_diff += 1
    ba, bb = open(pa, "rb").read(), open(pb, "rb").read()
    note = " (identique aux fins de ligne près)" if ba.replace(b"\r\n", b"\n") == bb.replace(b"\r\n", b"\n") else ""
    print(f"DIFFÉRENT   : {rel}{note}")
    if note or not rel.endswith(".csv"):
        continue
    try:
        X, Y = lire(pa), lire(pb)
    except Exception as e:  # noqa
        print(f"   lecture CSV impossible : {e}")
        continue
    print(f"   lignes {len(X)} / {len(Y)} ; en-têtes identiques : {X[0] == Y[0] if X and Y else None}")
    if len(X) != len(Y) or not X or X[0] != Y[0]:
        continue
    cellules = texte = 0
    ecarts = []
    exemples = []
    for i in range(1, len(X)):
        for j, (x, y) in enumerate(zip(X[i], Y[i])):
            cellules += 1
            if x == y:
                continue
            fx, fy = num(x), num(y)
            if fx is None or fy is None or fx != fx or fy != fy:
                texte += 1
                if len(exemples) < 3:
                    exemples.append((i, X[0][j], x, y))
                continue
            ecarts.append(abs(fx - fy) / max(abs(fx), abs(fy)))
            if len(exemples) < 3:
                exemples.append((i, X[0][j], x, y))
    print(f"   cellules {cellules} ; textes/NaN différents {texte} ; numériques différentes (octets) {len(ecarts)}")
    for s in SEUILS:
        print(f"   écart relatif > {s:g} : {sum(1 for e in ecarts if e > s)}")
    print(f"   écart relatif max : {max(ecarts) if ecarts else 0:.3e}")
    for e in exemples:
        print("   exemple ligne %d colonne %s : fourni=%s regénéré=%s" % e)
print(f"TOTAL fichiers fournis {len(fichiers)} : identiques {n_id}, différents {n_diff}, absents {n_abs}")
print("Présents dans B seulement : " + (", ".join(e for e in extra if e not in fichiers) or "aucun"))
