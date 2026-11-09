#!/usr/bin/env python3
"""Comparateur commun de fichiers CSV (CLAUDE.md art. 5 bis).

    python3 -I bin/compare_csv.py [--atol A] [--rtol R] [--delim D] REFERENCE NOUVEAU

Compare NOUVEAU (réexécution) à REFERENCE (sortie livrée par le paquet).
Deux cellules numériques sont égales si |a-b| <= atol + rtol*|ref| (défaut : 0 et 0,
égalité exacte). Aucune division : une référence nulle est traitée par atol seulement.
NaN égal NaN ; +inf égal +inf, -inf égal -inf, jamais un fini ; numérique contre texte :
différence ; texte contre texte : égalité exacte après suppression des blancs de bord.

Toute différence est une différence : fichier manquant ou illisible, colonne manquante ou
en trop, ordre des colonnes, nombre de lignes, ligne plus courte ou plus longue, cellule.
Code de sortie : 0 identiques (aux tolérances), 1 différences (listées, au plus 50 détaillées),
2 erreur d'usage. Dernière ligne de sortie : « RESULTAT: identique » ou « RESULTAT: differe (n) ».
"""
import argparse
import csv
import math
import sys

MAX_DETAIL = 50


def lire(chemin, delim):
    try:
        with open(chemin, newline="", encoding="utf-8-sig") as f:
            return list(csv.reader(f, delimiter=delim)), None
    except (OSError, UnicodeDecodeError, csv.Error) as e:
        return None, f"{chemin}: illisible ou manquant ({type(e).__name__}: {e})"


def num(s):
    s = s.strip()
    if s == "":
        return None
    try:
        return float(s)
    except ValueError:
        return None


def egales(r, n, atol, rtol):
    fr, fn = num(r), num(n)
    if fr is None or fn is None:
        if fr is None and fn is None:
            return r.strip() == n.strip()
        return False
    if math.isnan(fr) or math.isnan(fn):
        return math.isnan(fr) and math.isnan(fn)
    if math.isinf(fr) or math.isinf(fn):
        return fr == fn
    return abs(fr - fn) <= atol + rtol * abs(fr)


def compare(ref, new, atol, rtol):
    diffs = []
    if not ref or not new:
        if bool(ref) != bool(new):
            diffs.append(f"un des fichiers est vide (réf: {len(ref)} lignes, nouveau: {len(new)} lignes)")
        return diffs
    hr, hn = ref[0], new[0]
    if hr != hn:
        for c in hr:
            if c not in hn:
                diffs.append(f"colonne manquante dans le nouveau: {c!r}")
        for c in hn:
            if c not in hr:
                diffs.append(f"colonne en trop dans le nouveau: {c!r}")
        if set(hr) == set(hn) or (len(hr) == len(hn) and not diffs):
            diffs.append(f"ordre ou noms des colonnes changés: {hr} -> {hn}")
        if len(hr) != len(hn):
            diffs.append(f"nombre de colonnes: {len(hr)} -> {len(hn)}")
    if len(ref) != len(new):
        diffs.append(f"nombre de lignes: {len(ref)} -> {len(new)}")
    if hr != hn:
        return diffs  # structure différente : pas de comparaison cellule à cellule
    for i in range(min(len(ref), len(new))):
        lr, ln = ref[i], new[i]
        if len(lr) != len(ln):
            diffs.append(f"ligne {i + 1}: {len(lr)} cellules -> {len(ln)}")
        for j in range(max(len(lr), len(ln))):
            r = lr[j] if j < len(lr) else None
            n = ln[j] if j < len(ln) else None
            if r is None or n is None:
                diffs.append(f"ligne {i + 1}, colonne {hr[j] if j < len(hr) else j}: cellule absente "
                             f"({r!r} -> {n!r})")
            elif not egales(r, n, atol, rtol):
                diffs.append(f"ligne {i + 1}, colonne {hr[j] if j < len(hr) else j}: {r!r} -> {n!r}")
    return diffs


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--atol", type=float, default=0.0)
    p.add_argument("--rtol", type=float, default=0.0)
    p.add_argument("--delim", default=",")
    p.add_argument("reference")
    p.add_argument("nouveau")
    a = p.parse_args()
    if a.atol < 0 or a.rtol < 0 or math.isnan(a.atol) or math.isnan(a.rtol):
        print("tolérance invalide", file=sys.stderr)
        return 2
    ref, e1 = lire(a.reference, a.delim)
    new, e2 = lire(a.nouveau, a.delim)
    diffs = [e for e in (e1, e2) if e]
    if not diffs:
        diffs = compare(ref, new, a.atol, a.rtol)
    for d in diffs[:MAX_DETAIL]:
        print(d)
    if len(diffs) > MAX_DETAIL:
        print(f"... {len(diffs) - MAX_DETAIL} autres différences non détaillées")
    if diffs:
        print(f"RESULTAT: differe ({len(diffs)})")
        return 1
    print(f"RESULTAT: identique (atol={a.atol}, rtol={a.rtol})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
