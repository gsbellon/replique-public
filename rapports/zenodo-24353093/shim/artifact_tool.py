"""Module de remplacement minimal pour `artifact_tool`, introuvable sur PyPI (HORS PAQUET, écrit par Réplique).
Il accepte tous les appels que run_wchn.py fait sur les classeurs et n'écrit AUCUN fichier .xlsx.
Les calculs, le JSON et les figures de run_wchn.py ne passent pas par lui."""


class _Nul:
    def __getattr__(self, nom):
        return _Nul()

    def __call__(self, *a, **k):
        return _Nul()

    def __setattr__(self, nom, valeur):
        pass

    def save(self, chemin):
        print("artifact_tool (remplacement) : classeur non écrit :", chemin)


class Workbook(_Nul):
    @classmethod
    def create(cls):
        return _Nul()


class SpreadsheetFile(_Nul):
    @staticmethod
    def export_xlsx(wb):
        return _Nul()
