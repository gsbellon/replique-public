"""Compare les fichiers livrés (pkg/) aux fichiers après régénération (run/).
Ligne d'appel (sur sd-92569, depuis ~/work/z23585999) :
    python3 -I compare_pkg_run.py pkg run [tolerance_relative [tolerance_absolue]]
Pour chaque fichier de pkg : absent de run / identique octet à octet / différent. Pour les .json différents : comparaison
structurelle ; deux nombres sont égaux si leur écart est inférieur à la tolérance relative donnée (défaut 0 = égalité exacte)
OU à la tolérance absolue donnée (défaut 0) ; les chemins en écart sont listés (au plus 60 par fichier). Les .log/.pdf/.svg/.png différents sont seulement comptés. Ne lit que des données."""
import json
import os
import sys


ATOL = 0.0
LIMITE = 60  # chemins affichés par fichier


def diff(a, b, path, tol, out):
    if isinstance(a, dict) and isinstance(b, dict):
        for k in sorted(set(a) | set(b)):
            if k not in a or k not in b:
                out.append(path + "/" + str(k) + " (clé d'un seul côté)")
            else:
                diff(a[k], b[k], path + "/" + str(k), tol, out)
    elif isinstance(a, list) and isinstance(b, list):
        if len(a) != len(b):
            out.append(path + " (longueurs %d / %d)" % (len(a), len(b)))
        for i, (x, y) in enumerate(zip(a, b)):
            diff(x, y, path + "[%d]" % i, tol, out)
    elif isinstance(a, (int, float)) and isinstance(b, (int, float)) and not isinstance(a, bool) and not isinstance(b, bool):
        if a != b and abs(a - b) > tol * max(abs(a), abs(b)) and abs(a - b) > ATOL:
            out.append(path + " (%r / %r)" % (a, b))
    elif a != b:
        out.append(path + " (%r / %r)" % (str(a)[:40], str(b)[:40]))


def main():
    pkg, run = sys.argv[1], sys.argv[2]
    global ATOL
    tol = float(sys.argv[3]) if len(sys.argv) > 3 else 0.0
    ATOL = float(sys.argv[4]) if len(sys.argv) > 4 else 0.0
    n = ident = absent = 0
    autres = {}
    json_diff = []
    for root, _, files in sorted(os.walk(pkg)):
        for f in sorted(files):
            p = os.path.join(root, f)
            rel = os.path.relpath(p, pkg)
            q = os.path.join(run, rel)
            n += 1
            if not os.path.exists(q):
                absent += 1
                print("ABSENT apres execution :", rel)
                continue
            a = open(p, "rb").read()
            b = open(q, "rb").read()
            if a == b:
                ident += 1
                continue
            ext = os.path.splitext(f)[1]
            if ext == ".json":
                try:
                    out = []
                    diff(json.loads(a), json.loads(b), "", tol, out)
                    json_diff.append((rel, out))
                except Exception as e:
                    json_diff.append((rel, ["illisible : %s" % e]))
            else:
                autres.setdefault(ext or "(sans extension)", []).append(rel)
    print("fichiers livrés :", n, "| identiques octet à octet :", ident, "| absents après exécution :", absent)
    print("tolérance relative json :", tol)
    for ext, l in sorted(autres.items()):
        print("DIFFERENTS", ext, ":", len(l))
        for r in l:
            print("   ", r)
    nj_ecart = 0
    for rel, out in json_diff:
        if out:
            nj_ecart += 1
            print("JSON avec écart numérique/structurel :", rel, "(%d chemins)" % len(out))
            for o in out[:LIMITE]:
                print("      ", o)
        else:
            print("JSON différent octet à octet mais égal à la tolérance :", rel)
    print("json différents octet à octet :", len(json_diff), "dont avec écart à la tolérance :", nj_ecart)


main()
