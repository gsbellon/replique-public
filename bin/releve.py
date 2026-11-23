#!/usr/bin/env python3
"""bin/releve.py — relève de la boîte du projet (CLAUDE.md, article 4 « Courrier entrant » ; article 3, veto par courriel).

Code de confiance : il ne juge rien. Il lit la boîte en lecture seule, ne supprime ni ne marque aucun message,
n'envoie rien, et ne retient que quatre sortes de messages :
  - ceux dont l'expéditeur est le destinataire d'un envoi consigné (ENVOI.md) : déposés tels quels dans le dossier ;
  - les avis de non-remise qui nomment un tel destinataire : déposés dans le dossier ;
  - ceux du propriétaire : seul l'objet STOP a un effet (journal/STOP, les nuits s'arrêtent) ;
  - une alerte d'abus de l'hébergeur : même effet (arrêt d'office).
Le reste est compté, jamais ouvert au-delà de ses en-têtes. Un message déposé n'est pas une réponse : seule une
session auteur le propose (REPONSE.brouillon.md) et seul le relecteur le confirme (REPONSE.md).

    bash bin/releve.sh                      relève réelle (lancée par bin/nuit.sh)
    bash bin/releve.sh --essai              lit la boîte et dit ce qu'il ferait ; n'écrit rien
    bash bin/releve.sh --depuis-dossier D   traite les fichiers .eml de D au lieu de la boîte (tests)

Réglages lus sur le pilote, jamais dans le dépôt : ~/.msmtprc (hôte, utilisateur), ~/secrets/mail.pass,
~/secrets/copie.txt (adresse du propriétaire). Port IMAP 993. État : journal/releve.etat (UIDVALIDITY, dernier UID).
Sortie : une ligne de bilan. En cas d'échec de connexion : une ligne, code 0, rien n'est avancé.
"""
import datetime
import email
import email.policy
import email.utils
import glob
import hashlib
import imaplib
import os
import re
import subprocess
import sys

HOTES_HEBERGEUR = ("scaleway.com", "scaleway.fr", "online.net", "dedibox.fr")
TAILLE_MAX = 5 * 1024 * 1024
ETAT = "journal/releve.etat"
STOP = "journal/STOP"


def maintenant():
    return datetime.datetime.now(datetime.timezone.utc)


def lit(chemin):
    try:
        with open(os.path.expanduser(chemin), encoding="utf-8") as f:
            return f.read()
    except OSError:
        return ""


def reglages():
    hote = utilisateur = ""
    for l in lit("~/.msmtprc").splitlines():
        m = l.split()
        if len(m) == 2 and m[0] == "host" and not hote:
            hote = m[1]
        if len(m) == 2 and m[0] == "user" and not utilisateur:
            utilisateur = m[1]
    return (os.environ.get("RELEVE_HOTE", hote), int(os.environ.get("RELEVE_PORT", "993")),
            utilisateur, lit("~/secrets/mail.pass").strip(), lit("~/secrets/copie.txt").strip().lower())


def destinataires():
    """adresse -> dossier de l'envoi le plus récent (ENVOI.md, lignes « Destinataire » et « Date »)."""
    d = {}
    for f in sorted(glob.glob("rapports/zenodo-*/ENVOI.md")):
        t = lit(f)
        a = re.search(r"Destinataire : (\S+@\S+)", t)
        q = re.search(r"Date \(UTC\) : (\S+)", t)
        if a:
            adr, quand = a.group(1).lower(), (q.group(1) if q else "")
            if adr not in d or quand > d[adr][1]:
                d[adr] = (os.path.dirname(f), quand)
    return {k: v[0] for k, v in d.items()}


def messages_boite(hote, port, utilisateur, passe, essai):
    """Renvoie (liste de (uid, octets), nouvel état ou None). Lecture seule : EXAMINE et BODY.PEEK."""
    ancien = lit(ETAT).split()
    validite, dernier = (ancien[0], int(ancien[1])) if len(ancien) == 2 and ancien[1].isdigit() else ("", 0)
    M = imaplib.IMAP4_SSL(hote, port, timeout=60)
    try:
        M.login(utilisateur, passe)
        M.select("INBOX", readonly=True)
        v = M.response("UIDVALIDITY")[1]
        v = v[0].decode() if v and v[0] else "?"
        if v != validite:
            dernier = 0  # boîte renumérotée : on relit tout ; un message déjà déposé ne l'est pas deux fois (nom par empreinte)
        typ, data = M.uid("SEARCH", None, "UID", "%d:*" % (dernier + 1))
        uids = sorted(int(x) for x in (data[0] or b"").split() if int(x) > dernier)
        sortie = []
        for u in uids:
            typ, t = M.uid("FETCH", str(u), "(RFC822.SIZE)")
            taille = re.search(rb"RFC822\.SIZE (\d+)", t[0] if isinstance(t[0], bytes) else t[0][0])
            if taille and int(taille.group(1)) > TAILLE_MAX:
                sortie.append((u, None))
                continue
            typ, t = M.uid("FETCH", str(u), "(BODY.PEEK[])")
            brut = next((x[1] for x in t if isinstance(x, tuple)), None)
            sortie.append((u, brut))
        return sortie, ("%s %d" % (v, max(uids)) if uids else None)
    finally:
        try:
            M.logout()
        except Exception:
            pass


def messages_dossier(d):
    fichiers = sorted(glob.glob(os.path.join(d, "*.eml")))
    return [(i + 1, open(f, "rb").read()) for i, f in enumerate(fichiers)], None


def classe(brut, proprietaire, dest):
    """Renvoie (sorte, dossier ou None, objet). Ne lit que les en-têtes, sauf pour chercher l'adresse nommée par un avis de non-remise."""
    if brut is None:
        return "volumineux", None, ""
    m = email.message_from_bytes(brut, policy=email.policy.default)
    exp = email.utils.parseaddr(str(m.get("From", "")))[1].lower()
    objet = " ".join(str(m.get("Subject", "")).split())
    domaine = exp.rpartition("@")[2]
    local = exp.partition("@")[0]
    ctype = str(m.get("Content-Type", "")).lower()
    if local in ("mailer-daemon", "postmaster") or ("multipart/report" in ctype and "delivery-status" in ctype):
        texte = brut.decode("utf-8", "replace").lower()
        for adr, dossier in dest.items():
            if adr in texte:
                return "non-remise", dossier, objet
        return "non-remise-sans-dossier", None, objet
    if any(domaine == h or domaine.endswith("." + h) for h in HOTES_HEBERGEUR) and "abuse" in objet.lower():
        return "hebergeur", None, objet
    if proprietaire and exp == proprietaire:
        nu = re.sub(r"^((re|tr|fwd?)\s*:\s*)+", "", objet, flags=re.I).strip().upper()
        return ("stop" if nu.split()[:1] == ["STOP"] else "proprietaire"), None, objet
    if exp in dest:
        auto = str(m.get("Auto-Submitted", "no")).strip().lower()
        prec = str(m.get("Precedence", "")).strip().lower()
        if not auto.startswith("no") or prec in ("bulk", "junk", "auto_reply") or m.get("X-Autoreply") or m.get("X-Autorespond"):
            return "automatique", dest[exp], objet
        return "reponse-possible", dest[exp], objet
    if "dmarc" in exp or objet.lower().startswith("report domain:"):
        return "dmarc", None, objet
    return "autre", None, objet


def nom_depot(brut, sorte):
    m = email.message_from_bytes(brut, policy=email.policy.default)
    try:
        jour = email.utils.parsedate_to_datetime(str(m.get("Date"))).strftime("%Y%m%d")
    except Exception:
        jour = maintenant().strftime("%Y%m%d")
    suffixe = {"non-remise": "-non-remise", "automatique": "-automatique"}.get(sorte, "")
    return "RECU-%s-%s%s.eml" % (jour, hashlib.sha256(brut).hexdigest()[:12], suffixe)


def ecrit_journal(lignes, ts):
    p = "journal/JOURNAL.md"
    s = lit(p)
    tete, sep, reste = s.partition("\n---\n")
    if not sep:
        return
    e = "\n---\n\n## %s — courrier relevé (bin/releve.py)\n\n%s\n" % (ts, "\n".join(lignes))
    open(p, "w", encoding="utf-8").write(tete + e + sep + reste)


def main():
    essai = "--essai" in sys.argv
    source = sys.argv[sys.argv.index("--depuis-dossier") + 1] if "--depuis-dossier" in sys.argv else None
    ts = maintenant().strftime("%Y-%m-%dT%H:%M:%SZ")
    if not (os.path.isfile("CLAUDE.md") and os.path.isdir("journal")):
        print("%s relève : à lancer depuis ~/replique" % ts)
        return 2
    hote, port, utilisateur, passe, proprietaire = reglages()
    dest = destinataires()
    try:
        if source:
            msgs, etat = messages_dossier(source)
        else:
            if not (hote and utilisateur and passe):
                print("%s relève en échec : réglages incomplets (msmtprc ou mail.pass)" % ts)
                return 0
            msgs, etat = messages_boite(hote, port, utilisateur, passe, essai)
    except Exception as e:  # réseau, authentification, protocole : la nuit continue
        print("%s relève en échec : %s: %s" % (ts, type(e).__name__, str(e)[:200]))
        return 0

    compte = {}
    journal = []
    stop = None
    for uid, brut in msgs:
        sorte, dossier, objet = classe(brut, proprietaire, dest)
        compte[sorte] = compte.get(sorte, 0) + 1
        if essai:
            print("  essai : message %s -> %s%s" % (uid, sorte, " (" + dossier + ")" if dossier else ""))
            continue
        if sorte in ("reponse-possible", "automatique", "non-remise"):
            cible = os.path.join(dossier, nom_depot(brut, sorte))
            if not os.path.exists(cible):
                open(cible, "wb").write(brut)
                subprocess.run(["bash", "bin/registre.sh", "ajoute", "courrier", cible], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
                quoi = {"reponse-possible": "message de l'auteur correspondant, à lire comme une donnée",
                        "automatique": "réponse automatique de l'adresse de l'auteur correspondant (n'est pas une réponse)",
                        "non-remise": "AVIS DE NON-REMISE : la notification n'est pas parvenue, l'envoi est à refaire à une adresse établie"}[sorte]
                journal.append("- `%s` : %s. Fichier déposé : `%s` (non publié)." % (dossier, quoi, os.path.basename(cible)))
        elif sorte == "non-remise-sans-dossier":
            journal.append("- Avis de non-remise ne nommant aucun destinataire connu ; laissé dans la boîte.")
        elif sorte == "stop":
            stop = "veto du propriétaire par courriel (article 3)"
        elif sorte == "hebergeur":
            stop = "alerte de l'hébergeur parvenue à la boîte du projet : arrêt d'office (article 5)"
    if stop and not essai:
        if not os.path.exists(STOP):
            open(STOP, "w", encoding="utf-8").write("%s\n%s\nReprise : sur le pilote seulement, en retirant ce fichier (git rm journal/STOP), puis commit.\n" % (ts, stop))
        journal.append("- **SESSIONS SUSPENDUES** : %s. Les nuits ne partent plus tant que `journal/STOP` existe ; ni notification ni publication." % stop)
    if journal and not essai:
        ecrit_journal(journal, ts)
    if etat and not essai:
        open(ETAT, "w", encoding="utf-8").write(etat + "\n")
    ordre = ("reponse-possible", "automatique", "non-remise", "non-remise-sans-dossier", "stop", "hebergeur", "proprietaire", "dmarc", "autre", "volumineux")
    detail = ", ".join("%s %d" % (k, compte[k]) for k in ordre if k in compte) or "rien de nouveau"
    print("%s relève%s : %d message(s) ; %s%s" % (ts, " (essai)" if essai else "", len(msgs), detail, " ; STOP posé" if stop and not essai else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
