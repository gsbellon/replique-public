"""Compare cellule par cellule les CSV livrés (pkg/) et régénérés (run/).
Ligne d'appel (sur sd-92569, depuis ~/work/z23585999) :
    python3 -I compare_csv.py pkg run base_v0008/analysis/ownership_tail_paths.csv base_v0008/scf_pilot/equity_threshold_sensitivity.csv ...
Pour chaque fichier : nombre de lignes, de cellules, de cellules différentes en texte, de cellules différentes en valeur
numérique (float() différents), de cellules non numériques différentes, et plus grand écart relatif
|a-b| / max(|a|,|b|) sur les cellules numériques. Ne lit que des données."""
import csv
import sys


def main():
    pkg, run = sys.argv[1], sys.argv[2]
    for rel in sys.argv[3:]:
        a = list(csv.reader(open(pkg + "/" + rel, newline="")))
        b = list(csv.reader(open(run + "/" + rel, newline="")))
        if len(a) != len(b):
            print(rel, ": nombre de lignes différent", len(a), len(b))
            continue
        cells = txt = num = nonnum = 0
        maxrel = 0.0
        maxabs = 0.0
        for ra, rb in zip(a, b):
            if len(ra) != len(rb):
                nonnum += 1
                continue
            for x, y in zip(ra, rb):
                cells += 1
                if x == y:
                    continue
                txt += 1
                try:
                    fx, fy = float(x), float(y)
                except ValueError:
                    nonnum += 1
                    continue
                if fx != fy:
                    num += 1
                    d = abs(fx - fy)
                    m = max(abs(fx), abs(fy))
                    maxabs = max(maxabs, d)
                    if m > 0:
                        maxrel = max(maxrel, d / m)
        print(rel, ": lignes", len(a), "| cellules", cells, "| différentes en texte", txt, "| différentes en valeur", num,
              "| non numériques différentes", nonnum, "| écart relatif max %.3g" % maxrel, "| écart absolu max %.3g" % maxabs)


main()
