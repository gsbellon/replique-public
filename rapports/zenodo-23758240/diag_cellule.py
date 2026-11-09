"""Diagnostic de la ligne qui dépasse l'arrondi (magnitude 2, durée 600, rampe 10, délai 0, pred_holt).
Lit deux raw_results.csv (livré, régénéré) avec la bibliothèque standard seulement ; n'exécute rien du paquet.
Appel : python3 -I diag_cellule.py <results livré> <results régénéré>
Pour chaque graine : sla_viol_rate de reactive et de pred_holt dans chaque jeu, différence d, et signe de d.
"""
import csv
import sys

cle = ("2", "600", "10", "0")


def charge(chemin):
    t = {}
    with open(chemin + "/raw_results.csv", newline="") as f:
        for r in csv.DictReader(f):
            if (r["magnitude"], r["duration"], r["ramp"], r["delta"]) == cle:
                t[(r["policy"], int(r["seed"]))] = float(r["sla_viol_rate"])
    return t


a, b = charge(sys.argv[1]), charge(sys.argv[2])
seeds = sorted({s for (_, s) in a})
print("graine  d_livré  d_régénéré  signe_livré  signe_régénéré  reactive_livré==régénéré  holt_livré==régénéré")
sg = lambda x: (x > 0) - (x < 0)
for s in seeds:
    da = a[("pred_holt", s)] - a[("reactive", s)]
    db = b[("pred_holt", s)] - b[("reactive", s)]
    print(s, repr(da), repr(db), sg(da), sg(db),
          a[("reactive", s)] == b[("reactive", s)], a[("pred_holt", s)] == b[("pred_holt", s)])
for nom, t in (("livré", a), ("régénéré", b)):
    d = [t[("pred_holt", s)] - t[("reactive", s)] for s in seeds]
    print(nom, "n =", len(d), "d<0 :", sum(x < 0 for x in d), "d>0 :", sum(x > 0 for x in d), "d==0 :", sum(x == 0 for x in d))
