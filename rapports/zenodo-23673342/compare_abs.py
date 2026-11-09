"""Ligne d'appel (sur sd-92569, depuis ~/work/z23673342) :
    python3 -I compare_abs.py pkg/output run_full/output audit/interference.csv audit/monotonicity_person.csv audit/monotonicity_profile.csv
Pour chaque CSV nommé : écart absolu maximal |a-b| sur les cellules numériques différentes, et nombre de cellules dont
l'écart relatif dépasse 1e-3 avec, parmi elles, l'écart absolu maximal et la valeur absolue maximale des deux cellules.
Ne lit que des fichiers ; modules csv, sys, os de la bibliothèque standard."""
import csv, os, sys

A, B = sys.argv[1], sys.argv[2]
for rel in sys.argv[3:]:
    X = list(csv.reader(open(os.path.join(A, rel), newline="", encoding="utf-8")))
    Y = list(csv.reader(open(os.path.join(B, rel), newline="", encoding="utf-8")))
    abs_all, abs_gros, val_gros = [], [], []
    for i in range(1, len(X)):
        for x, y in zip(X[i], Y[i]):
            if x == y:
                continue
            try:
                fx, fy = float(x), float(y)
            except ValueError:
                continue
            d = abs(fx - fy)
            abs_all.append(d)
            if d / max(abs(fx), abs(fy)) > 1e-3:
                abs_gros.append(d)
                val_gros.append(max(abs(fx), abs(fy)))
    print(f"{rel} : cellules numériques différentes {len(abs_all)} ; écart absolu max {max(abs_all, default=0):.3e}")
    print(f"   dont écart relatif > 1e-3 : {len(abs_gros)} ; écart absolu max {max(abs_gros, default=0):.3e} ; valeur absolue max des deux cellules {max(val_gros, default=0):.3e}")
