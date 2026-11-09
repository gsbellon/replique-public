"""Compare deux JSON feuille par feuille (même structure attendue).
Ligne d'appel (sur sd-92569, depuis ~/work/z23647165) :
  python3 -I compare_json.py pkg/replication/output/results.json run/output/results.json
Sortie : nombre de feuilles, feuilles absentes d'un côté, feuilles non numériques différentes,
feuilles numériques différentes (nombre, écart relatif max, 10 plus grands écarts)."""
import json, math, sys

def feuilles(x, chemin=""):
    if isinstance(x, dict):
        for k in sorted(x):
            yield from feuilles(x[k], chemin + "/" + str(k))
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from feuilles(v, chemin + "[" + str(i) + "]")
    else:
        yield chemin, x

a = dict(feuilles(json.load(open(sys.argv[1]))))
b = dict(feuilles(json.load(open(sys.argv[2]))))
print("feuilles livré:", len(a), "régénéré:", len(b))
print("seulement dans le livré:", len(set(a) - set(b)), sorted(set(a) - set(b))[:10])
print("seulement dans le régénéré:", len(set(b) - set(a)), sorted(set(b) - set(a))[:10])
autres, nums, egaux = [], [], 0
for k in sorted(set(a) & set(b)):
    x, y = a[k], b[k]
    if x == y:
        egaux += 1
    elif isinstance(x, (int, float)) and isinstance(y, (int, float)) and not isinstance(x, bool) and not isinstance(y, bool):
        if math.isnan(x) and math.isnan(y):
            egaux += 1
            continue
        d = abs(x - y)
        nums.append((d / max(abs(x), abs(y), 1e-300), d, k, x, y))
    else:
        autres.append((k, x, y))
print("feuilles identiques:", egaux)
print("feuilles non numériques différentes:", len(autres), autres[:10])
print("feuilles numériques différentes:", len(nums))
nums.sort(reverse=True)
if nums:
    print("écart relatif max:", "%.3g" % nums[0][0], "| écart absolu max:", "%.3g" % max(n[1] for n in nums))
for r, d, k, x, y in nums[:10]:
    print("  rel %.3g abs %.3g %s livré=%r régénéré=%r" % (r, d, k, x, y))
