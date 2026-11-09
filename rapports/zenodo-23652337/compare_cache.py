"""Compare deux fichiers npz : python3 -I compare_cache.py <livré> <recalculé>. Affiche forme et écarts max par tableau."""
import sys
import numpy as np

old, new = np.load(sys.argv[1]), np.load(sys.argv[2])
print("tableaux livré :", sorted(old.files), "recalculé :", sorted(new.files))
for k in sorted(old.files):
    a, b = old[k], new[k]
    print(k, "formes", a.shape, b.shape, end=" ")
    if a.shape != b.shape:
        print("FORMES DIFFÉRENTES")
        continue
    d = np.abs(a - b)
    print("écart abs max %.3e" % d.max(), "relatif max %.3e" % (d / np.maximum(np.abs(a), 1e-300)).max(),
          "identique" if np.array_equal(a, b) else "différent")
