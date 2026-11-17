"""Convertit en CSV chaque fichier .parquet d'un dossier (conversion seule, aucune comparaison).

Appel (dans le conteneur, voir compare.sh) :
    python -I parquet_vers_csv.py <dossier_parquet> <dossier_csv> [<dossier_csv_trie>]
Les flottants sont écrits par polars avec la représentation la plus courte qui se relit à l'identique.
Avec un troisième argument, une seconde copie est écrite, diagnostic séparé et nommé comme tel : lignes triées sur leurs
quatre premières colonnes (clés : problème, taille de population, niveau, mode ou comparaison) et sans les deux colonnes
`p_holm_without_hypervolume` et `significant_without_hypervolume` si elles existent. La copie brute reste la référence.
"""
import sys
from pathlib import Path

import polars as pl

src, dst = Path(sys.argv[1]), Path(sys.argv[2])
dst_tri = Path(sys.argv[3]) if len(sys.argv) > 3 else None
dst.mkdir(parents=True, exist_ok=True)
if dst_tri:
    dst_tri.mkdir(parents=True, exist_ok=True)
EXTRA = ["p_holm_without_hypervolume", "significant_without_hypervolume"]
for p in sorted(src.glob("*.parquet")):
    df = pl.read_parquet(p)
    df.write_csv(dst / (p.stem + ".csv"))
    print(f"{p.name}: {df.height} lignes, {df.width} colonnes")
    if dst_tri:
        d2 = df.drop([c for c in EXTRA if c in df.columns]).sort(df.columns[:4], maintain_order=True)
        d2.write_csv(dst_tri / (p.stem + ".csv"))
