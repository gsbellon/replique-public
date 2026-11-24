"""Compare deux répertoires de CSV : fins de ligne normalisées, cellules numériques comparées avec
une tolérance relative (argument 3), autres cellules à l'identique.
Ligne d'appel : python3 -I compare_tolerance.py <repertoire fourni> <repertoire regenere> <tol relative>
Sortie : une ligne par fichier (CELLULES, EXACT = cellules numériques égales au caractère près, TOL = égales à la tolérance près,
HORS = hors tolérance, TEXTE_DIFF = cellules non numériques différentes, FORME = nombre de lignes/colonnes différent),
puis le plus grand écart relatif observé par fichier."""
import csv
import math
import os
import sys

pkg, run, tol = sys.argv[1], sys.argv[2], float(sys.argv[3])


def lit(chemin):
    with open(chemin, newline="") as f:
        return list(csv.reader(f))


def nombre(s):
    try:
        return float(s)
    except ValueError:
        return None


tot = {"CELLULES": 0, "EXACT": 0, "TOL": 0, "HORS": 0, "TEXTE_DIFF": 0, "FORME": 0}
for nom in sorted(os.listdir(pkg)):
    a, b = lit(os.path.join(pkg, nom)), lit(os.path.join(run, nom))
    c = {"CELLULES": 0, "EXACT": 0, "TOL": 0, "HORS": 0, "TEXTE_DIFF": 0, "FORME": 0}
    pire = 0.0
    if len(a) != len(b) or any(len(x) != len(y) for x, y in zip(a, b)):
        c["FORME"] = 1
    else:
        for x, y in zip(a, b):
            for u, v in zip(x, y):
                c["CELLULES"] += 1
                if u == v:
                    c["EXACT"] += 1
                    continue
                fu, fv = nombre(u), nombre(v)
                if fu is None or fv is None:
                    c["TEXTE_DIFF"] += 1
                    continue
                if math.isnan(fu) and math.isnan(fv):
                    c["EXACT"] += 1
                    continue
                ecart = abs(fu - fv) / max(abs(fu), abs(fv), 1e-300)
                pire = max(pire, ecart)
                if ecart <= tol:
                    c["TOL"] += 1
                else:
                    c["HORS"] += 1
    for k in tot:
        tot[k] += c[k]
    print(nom, " ".join(f"{k}={v}" for k, v in c.items()), f"ecart_rel_max={pire:.3g}")
print("TOTAL", " ".join(f"{k}={v}" for k, v in tot.items()))
