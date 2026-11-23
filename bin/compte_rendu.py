#!/usr/bin/env python3
"""bin/compte_rendu.py — comptes rendus au propriétaire (CLAUDE.md, article 5).

    bash bin/compte_rendu.sh bulletin [--essai]   bulletin du matin : la nuit en dix lignes
    bash bin/compte_rendu.sh etat [--essai]       état des rapports, chaque lundi : une fiche par paquet

Code de confiance : il assemble ce qui est déjà au dépôt (USAGE.tsv, registre, rapports, FICHE.md, journaux des
scripts) et ne juge rien. Il écrit sur la sortie standard un message complet (en-têtes et corps) ; bin/compte_rendu.sh
le remet à msmtp. Avec --essai, le message est seulement affiché. Destinataire : ~/secrets/copie.txt, jamais dans le dépôt.
Ces messages ne sont pas publiés ; ils peuvent nommer des dossiers sous embargo, puisqu'ils ne vont qu'au propriétaire.
"""
import datetime
import email.message
import email.policy
import glob
import os
import re
import subprocess
import sys


def lit(chemin):
    try:
        with open(os.path.expanduser(chemin), encoding="utf-8") as f:
            return f.read()
    except OSError:
        return ""


def rapports():
    """Liste de dict par dossier portant un RAPPORT.md."""
    out = []
    for r in sorted(glob.glob("rapports/zenodo-*/RAPPORT.md")):
        t = lit(r)
        d = os.path.dirname(r)
        etat = (re.search(r"état : (\S+)", t.split("\n", 1)[0]) or [None, "?"])[1]
        v = re.search(r"\*\*(reproduit|divergent|inexécutable)\*\*", t)
        out.append({"dossier": os.path.basename(d), "chemin": d, "etat": etat, "verdict": v.group(1) if v else "?",
                    "fiche": lit(os.path.join(d, "FICHE.md")).strip(),
                    "envoi": os.path.isfile(os.path.join(d, "ENVOI.md")),
                    "recu": len(glob.glob(os.path.join(d, "RECU-*.eml"))),
                    "reponse": os.path.isfile(os.path.join(d, "REPONSE.md"))})
    return out


def registre():
    lignes = [l.split("\t") for l in lit("registre/chaine.tsv").split("\n") if l]
    return [l for l in lignes if len(l) == 7]


def decompte(rs):
    pub = [r for r in rs if r["etat"] == "publiable"]
    c = {v: sum(1 for r in pub if r["verdict"] == v) for v in ("reproduit", "divergent", "inexécutable")}
    return len(pub), c, sum(1 for r in rs if r["etat"] == "brouillon"), sum(1 for r in rs if r["etat"] == "retiré")


def bulletin():
    now = datetime.datetime.now(datetime.timezone.utc)
    debut = (now - datetime.timedelta(hours=16)).strftime("%Y-%m-%dT%H%M%SZ")   # la nuit : les seize dernières heures
    debut_iso = (now - datetime.timedelta(hours=16)).strftime("%Y-%m-%dT%H:%M:%SZ")
    usage = [l.split("\t") for l in lit("journal/USAGE.tsv").split("\n")[1:] if l]
    nuit = [u for u in usage if u[0] >= debut]
    anomalies = []
    suspendu = os.path.isfile("journal/STOP")
    L = []
    if suspendu:
        L.append("SESSIONS SUSPENDUES : " + " — ".join(lit("journal/STOP").strip().split("\n")[:2]))
    if nuit:
        codes = sorted(set(u[2] for u in nuit))
        cout = sum(float(u[4]) for u in nuit if re.fullmatch(r"[0-9.]+", u[4]))
        L.append("Nuit : %d sessions (%d auteur, %d relecteur), codes de sortie : %s ; coût estimé %.2f $." % (
            len(nuit), sum(1 for u in nuit if u[1] == "auteur"), sum(1 for u in nuit if u[1] == "relecteur"), ", ".join(codes), cout))
        if codes != ["0"]:
            anomalies.append("session(s) en code " + ", ".join(c for c in codes if c != "0"))
    else:
        L.append("Nuit : aucune session depuis seize heures.")
        if not suspendu:
            anomalies.append("aucune session cette nuit")
    rs = rapports()
    n, c, brouillons, retires = decompte(rs)
    L.append("Rapports : %d portent un verdict (%d reproduit, %d divergent, %d inexécutable) ; %d en brouillon ; %d retiré(s). Objectif : 50 au 17 janvier 2027." % (
        n, c["reproduit"], c["divergent"], c["inexécutable"], brouillons, retires))
    reg = registre()
    nouveaux = sorted(set(l[3].split("/")[1] for l in reg if l[1] >= debut_iso and l[3].startswith("rapports/zenodo-") and l[3].endswith("/RAPPORT.md")))
    L.append("Rapports inscrits ou réinscrits cette nuit : " + (", ".join(nouveaux) if nouveaux else "aucun") + ".")
    attente = [r["dossier"] for r in rs if r["etat"] == "publiable" and r["verdict"] == "divergent" and not r["envoi"]]
    if attente:
        L.append("Divergents non notifiés, adresse à établir : " + ", ".join(attente) + ".")
    notif = [l for l in lit("journal/notifications.log").split("\n") if l[:20] >= debut_iso and "notification envoyée" in l]
    L.append("Notifications envoyées cette nuit : " + (" ; ".join(l.split(" : ", 1)[-1] for l in notif) if notif else "aucune") + ".")
    releve = [l for l in lit("journal/releve.log").split("\n") if l[:20] >= debut_iso]
    L.append("Courrier : " + (releve[-1].split(" ", 1)[-1] if releve else "aucune relève cette nuit") + ".")
    if releve and "en échec" in releve[-1]:
        anomalies.append("relève du courrier en échec")
    recus = [r["dossier"] + " (%d)" % r["recu"] for r in rs if r["recu"] and not r["reponse"]]
    if recus:
        L.append("Messages reçus en attente de lecture par une session : " + ", ".join(recus) + ".")
    v = subprocess.run(["bash", "bin/registre.sh", "verifie"], capture_output=True, text=True)
    vl = [l for l in (v.stdout + v.stderr).strip().split("\n") if l]
    L.append("Registre : " + (vl[-1][:90] if vl else "aucune réponse de verifie") + ("" if v.returncode == 0 else " (%d ligne(s) en défaut)" % len(vl)))
    if v.returncode != 0:
        anomalies.append("registre : " + vl[0][:80] if vl else "registre : verifie en échec")
    pub = [l for l in lit("journal/publication.log").split("\n") if l]
    L.append("Publication : " + (pub[-1][:110] if pub else "aucune trace") + ".")
    if not suspendu and not any(l[:20] >= debut_iso and ("publication poussée" in l or "rien à publier" in l) for l in pub[-6:]):
        anomalies.append("pas de publication cette nuit")
    jour = now.astimezone().strftime("%d/%m")
    if anomalies:
        objet = "[Réplique] %s : ANOMALIE — %s" % (jour, " ; ".join(anomalies))
        L.insert(0, "ANOMALIE : " + " ; ".join(anomalies) + ". Une panne du projet n'est jamais urgente : dans le doute, ne rien toucher.")
    elif suspendu:
        objet = "[Réplique] %s : sessions suspendues" % jour
    else:
        objet = "[Réplique] %s : RAS — %d sessions, %d rapports" % (jour, len(nuit), n)
    return objet, "\n".join(L) + "\n"


def etat():
    now = datetime.datetime.now(datetime.timezone.utc)
    semaine = (now - datetime.timedelta(days=7)).strftime("%Y-%m-%dT%H:%M:%SZ")
    premiere = {}
    for l in registre():
        if l[3].startswith("rapports/zenodo-") and l[3].endswith("/RAPPORT.md"):
            premiere.setdefault(l[3].split("/")[1], l[1])
    rs = rapports()
    n, c, brouillons, retires = decompte(rs)
    neufs = [r for r in rs if premiere.get(r["dossier"], "") >= semaine]
    L = ["État des rapports au %s." % now.astimezone().strftime("%d/%m/%Y"),
         "%d rapports portent un verdict : %d reproduit, %d divergent, %d inexécutable ; %d en brouillon ; %d retiré(s). Cette semaine : %d nouveau(x). Objectif : 50 au 17 janvier 2027." % (
             n, c["reproduit"], c["divergent"], c["inexécutable"], brouillons, retires, len(neufs)),
         "Les créateurs et les articles liés sont ceux que donnent la fiche Zenodo et le README de chaque paquet ; aucune recherche n'est faite sur les personnes.",
         ""]
    for r in sorted(rs, key=lambda r: premiere.get(r["dossier"], ""), reverse=True):
        marque = []
        if r in neufs:
            marque.append("NOUVEAU")
        if r["verdict"] == "divergent" and r["etat"] == "publiable":
            marque.append("réponse reçue" if r["reponse"] else ("notifié" if r["envoi"] else "NON NOTIFIÉ, adresse à établir"))
        L.append("=== %s — %s, %s%s" % (r["dossier"], r["etat"], r["verdict"], (" — " + ", ".join(marque)) if marque else ""))
        L.append(r["fiche"] if r["fiche"] else "(fiche à venir)")
        L.append("")
    return "[Réplique] état des rapports : %d, dont %d cette semaine" % (n, len(neufs)), "\n".join(L)


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else ""
    if mode not in ("bulletin", "etat") or not os.path.isfile("CLAUDE.md"):
        print("usage : bash bin/compte_rendu.sh bulletin|etat [--essai], depuis ~/replique", file=sys.stderr)
        return 2
    a = lit("~/secrets/copie.txt").strip()
    if not a:
        print("adresse du propriétaire absente (~/secrets/copie.txt)", file=sys.stderr)
        return 3
    objet, corps = bulletin() if mode == "bulletin" else etat()
    if "--essai" in sys.argv:
        print("Objet : " + objet + "\n\n" + corps)
        return 0
    m = email.message.EmailMessage(policy=email.policy.default)
    m["From"] = "Réplique <contact@replique-lab.org>"
    m["To"] = a
    m["Subject"] = objet
    m["Auto-Submitted"] = "auto-generated"
    m.set_content(corps, charset="utf-8", cte="quoted-printable")
    sys.stdout.buffer.write(m.as_bytes())
    return 0


if __name__ == "__main__":
    sys.exit(main())
