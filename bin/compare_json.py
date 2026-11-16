#!/usr/bin/env python3
"""Comparateur commun de fichiers JSON (CLAUDE.md art. 5 bis).

    python3 -I bin/compare_json.py [--atol A] [--rtol R] REFERENCE NOUVEAU

Compare NOUVEAU (réexécution) à REFERENCE (sortie livrée par le paquet), valeur par valeur.
Deux nombres sont égaux si |a-b| <= atol + rtol*|ref| (défaut : 0 et 0, égalité exacte).
Aucune division : une référence nulle est traitée par atol seulement. NaN égal NaN ;
+inf égal +inf, -inf égal -inf, jamais un fini. Un booléen n'est pas un nombre.
Chaînes, booléens et null : égalité exacte. Types différents : différence.

Toute différence est une différence : fichier manquant ou illisible, clé manquante ou en trop,
longueur de liste, type, valeur. L'ordre des clés d'un objet ne compte pas ; l'ordre d'une liste compte.
Rien n'est ignoré : un champ qui change par nature (date, durée, chemin) sort comme différence,
et c'est le rapport qui l'explique.
Code de sortie : 0 identiques (aux tolérances), 1 différences (listées, au plus 50 détaillées),
2 erreur d'usage. Dernière ligne de sortie : « RESULTAT: identique » ou « RESULTAT: differe (n) ».
"""
import argparse
import json
import math
import sys

MAX_DETAIL = 50


def lire(chemin):
    try:
        with open(chemin, encoding="utf-8-sig") as f:
            return json.load(f), None
    except (OSError, UnicodeDecodeError, ValueError, RecursionError) as e:
        return None, f"{chemin}: illisible, manquant ou JSON invalide ({type(e).__name__}: {e})"


def est_nombre(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)


def nom_type(v):
    if v is None:
        return "null"
    if isinstance(v, bool):
        return "booléen"
    if est_nombre(v):
        return "nombre"
    if isinstance(v, str):
        return "chaîne"
    if isinstance(v, list):
        return "liste"
    if isinstance(v, dict):
        return "objet"
    return type(v).__name__


def nombres_egaux(r, n, atol, rtol):
    fr, fn = float(r), float(n)
    if math.isnan(fr) or math.isnan(fn):
        return math.isnan(fr) and math.isnan(fn)
    if math.isinf(fr) or math.isinf(fn):
        return fr == fn
    if isinstance(r, int) and isinstance(n, int) and atol == 0 and rtol == 0:
        return r == n
    return abs(fr - fn) <= atol + rtol * abs(fr)


def compare(ref, new, atol, rtol, chemin, diffs):
    if est_nombre(ref) and est_nombre(new):
        if not nombres_egaux(ref, new, atol, rtol):
            diffs.append(f"{chemin}: {ref!r} -> {new!r}")
        return
    if nom_type(ref) != nom_type(new):
        diffs.append(f"{chemin}: type {nom_type(ref)} -> {nom_type(new)}")
        return
    if isinstance(ref, dict):
        for k in ref:
            if k not in new:
                diffs.append(f"{chemin}.{k}: clé manquante dans le nouveau")
        for k in new:
            if k not in ref:
                diffs.append(f"{chemin}.{k}: clé en trop dans le nouveau")
        for k in ref:
            if k in new:
                compare(ref[k], new[k], atol, rtol, f"{chemin}.{k}", diffs)
        return
    if isinstance(ref, list):
        if len(ref) != len(new):
            diffs.append(f"{chemin}: longueur de liste {len(ref)} -> {len(new)}")
        for i in range(min(len(ref), len(new))):
            compare(ref[i], new[i], atol, rtol, f"{chemin}[{i}]", diffs)
        return
    if ref != new:
        diffs.append(f"{chemin}: {ref!r} -> {new!r}")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--atol", type=float, default=0.0)
    p.add_argument("--rtol", type=float, default=0.0)
    p.add_argument("reference")
    p.add_argument("nouveau")
    a = p.parse_args()
    if a.atol < 0 or a.rtol < 0 or math.isnan(a.atol) or math.isnan(a.rtol):
        print("tolérance invalide", file=sys.stderr)
        return 2
    ref, e1 = lire(a.reference)
    new, e2 = lire(a.nouveau)
    diffs = [e for e in (e1, e2) if e]
    if not diffs:
        try:
            compare(ref, new, a.atol, a.rtol, "$", diffs)
        except RecursionError:
            diffs.append("structure trop profonde pour être comparée")
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
