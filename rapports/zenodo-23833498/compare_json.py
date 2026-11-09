"""Compare deux JSON (livré, régénéré) feuille par feuille. Ne lit que du JSON ; n'exécute rien du paquet.
Ligne d'appel (sur sd-92569, depuis ~/work/z23833498) :
  python3 -I compare_json.py pkg/archetype_results.json run/archetype_results.json
Imprime : nombre de feuilles, feuilles différentes (chemin, livré, régénéré), écart absolu max, écart relatif max."""
import json, sys


def feuilles(x, chemin=""):
    if isinstance(x, dict):
        for k in x:
            yield from feuilles(x[k], f"{chemin}/{k}")
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from feuilles(v, f"{chemin}[{i}]")
    else:
        yield chemin, x


a = dict(feuilles(json.load(open(sys.argv[1]))))
b = dict(feuilles(json.load(open(sys.argv[2]))))
print("feuilles livrées :", len(a), "| régénérées :", len(b), "| chemins seulement d'un côté :", len(set(a) ^ set(b)))
diff = [(p, a[p], b[p]) for p in a if p in b and a[p] != b[p]]
print("feuilles différentes :", len(diff))
amax = rmax = 0.0
for p, u, v in diff:
    if isinstance(u, (int, float)) and isinstance(v, (int, float)) and not isinstance(u, bool):
        d = abs(u - v)
        amax = max(amax, d)
        if u != 0:
            rmax = max(rmax, d / abs(u))
    else:
        print("  non numérique :", p, repr(u), repr(v))
for p, u, v in diff[:15]:
    print("  ", p, u, v)
print("écart absolu max :", amax)
print("écart relatif max :", rmax)
