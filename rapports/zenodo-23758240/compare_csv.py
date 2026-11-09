"""Ligne d'appel (sur sd-92569, depuis ~/work/z23758240) :
    python3 -I compare_csv.py pkg/autoscaling-sensitivity-study/results run/results
(lancée par lance_compare_csv.sh ; sortie conservée par bin/capture.sh -> comparaison_csv.log)
Compare cellule par cellule les cinq CSV de results/ (fourni vs régénéré). Cellule numérique : écart relatif
|a-b| / max(|a|,|b|) (0 si a == b) ; texte : égalité stricte. Ne lit que des CSV ; module csv de la bibliothèque standard."""
import csv, sys, os

dossier_a, dossier_b = sys.argv[1], sys.argv[2]
SEUILS = [0.0, 1e-12, 1e-9, 1e-6, 1e-3, 1e-2, 1e-1]


def num(s):
    try:
        return float(s)
    except ValueError:
        return None


for nom in sorted(f for f in os.listdir(dossier_a) if f.endswith(".csv")):
    A = list(csv.reader(open(os.path.join(dossier_a, nom), newline="", encoding="utf-8")))
    B = list(csv.reader(open(os.path.join(dossier_b, nom), newline="", encoding="utf-8")))
    print(f"== {nom} : lignes {len(A)} / {len(B)} ; en-têtes identiques : {A[0] == B[0]}")
    if len(A) != len(B) or A[0] != B[0]:
        continue
    cellules = diff_texte = nan_a = nan_b = 0
    ecarts = []
    exemples = []
    gros = []
    for i in range(1, len(A)):
        for j, (x, y) in enumerate(zip(A[i], B[i])):
            cellules += 1
            if x == y:
                continue
            fx, fy = num(x), num(y)
            if fx is None or fy is None:
                diff_texte += 1
                if len(exemples) < 5:
                    exemples.append((i, A[0][j], x, y))
                continue
            if fx != fx or fy != fy:  # NaN d'un seul côté
                diff_texte += 1
                if len(exemples) < 5:
                    exemples.append((i, A[0][j], x, y))
                continue
            r = abs(fx - fy) / max(abs(fx), abs(fy))
            ecarts.append(r)
            if r > 1e-9:
                gros.append((i, A[0][j], x, y, r))
            if len(exemples) < 5:
                exemples.append((i, A[0][j], x, y))
    print(f"   cellules : {cellules} ; textes/NaN différents : {diff_texte} ; numériques différentes (octets) : {len(ecarts)}")
    for s in SEUILS:
        print(f"   écart relatif > {s:g} : {sum(1 for e in ecarts if e > s)}")
    print(f"   écart relatif max : {max(ecarts) if ecarts else 0:.3e}")
    for e in exemples:
        print("   exemple ligne %d colonne %s : fourni=%s regénéré=%s" % e)
    for g in gros:
        print("   ÉCART > 1e-9 ligne %d (%s) colonne %s : fourni=%s regénéré=%s relatif=%.3e" % ((g[0], ",".join(A[g[0]][:6])) + g[1:]))
