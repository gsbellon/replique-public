"""Diagnostic de l'écart d'empreinte du VIX (check_vix.log). Lecture seule.
Ligne d'appel : voir diag_vix.sh. Compare le VIX téléchargé le 2026-10-27 au nombre de jours (n=9279 jusqu'au 2026-09-22) consigné
dans data/raw/FRED_download_log.txt du paquet, et indique les dates dont la valeur est manquante."""
import pandas as pd

d = pd.read_csv("data/raw/FRED_VIXCLS.csv", parse_dates=["date"])
a = d[d["date"] <= "2026-09-22"]
print("lignes <= 2026-09-22 :", len(a), "; non manquantes :", int(a["VIXCLS"].notna().sum()), "(paquet : n=9279)")
print("première / dernière date non manquante :", a.dropna()["date"].min().date(), a.dropna()["date"].max().date())
print("dates manquantes (10 premières) :", [x.date().isoformat() for x in a[a["VIXCLS"].isna()]["date"][:10]])
print("sha256 du texte écrit sans dropna : voir check_vix.log ; lignes de fenêtre 2007-08..2026-06 :", int(((d["date"] >= "2007-08-01") & (d["date"] <= "2026-06-30")).sum()))
