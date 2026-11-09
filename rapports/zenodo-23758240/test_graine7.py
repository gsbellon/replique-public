"""Test de l'hypothèse : la graine 7 (d = -3,47e-18, bruit flottant) compte comme égalité chez les auteurs.
Reprend les lignes de analyse.py (wilcoxon zsplit, eff) sur le livré, tel quel puis avec d de la graine 7 mis à 0.
Lit raw_results.csv livré ; compare aux valeurs livrées de paired_vs_reactive.csv (ligne de la cellule 2/600/10/0, pred_holt).
Appel (dans le conteneur) : python test_graine7.py <results livré>
"""
import sys
import numpy as np
import pandas as pd
from scipy.stats import wilcoxon

out = sys.argv[1]
df = pd.read_csv(f"{out}/raw_results.csv")
g = df[(df.magnitude == 2) & (df.duration == 600) & (df.ramp == 10) & (df.delta == 0)]
r = g[g.policy == "reactive"].set_index("seed")
p = g[g.policy == "pred_holt"].set_index("seed")
d = (p["sla_viol_rate"] - r["sla_viol_rate"]).dropna()
print("d graine 7 :", repr(d.loc[7]))
for nom, dd in (("tel quel", d), ("graine 7 forcée à 0", d.where(d.index != 7, 0.0))):
    pv = wilcoxon(dd, zero_method="zsplit").pvalue
    eff = (np.sum(dd < 0) - np.sum(dd > 0)) / len(dd)
    print(nom, "wins_minus_losses =", repr(float(eff)), "p_value =", repr(float(pv)))
liv = pd.read_csv(f"{out}/paired_vs_reactive.csv")
l = liv[(liv.magnitude == 2) & (liv.duration == 600) & (liv.ramp == 10) & (liv.delta == 0) & (liv.policy == "pred_holt")]
print("livré :", l[["wins_minus_losses", "p_value"]].to_dict("records"))
