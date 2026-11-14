#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24218418/compare_crlf.sh sd-92569:work/z24218418/
#   bin/capture.sh rapports/zenodo-24218418/compare_crlf.log 'cd ~/work/z24218418 && sh compare_crlf.sh'
# compare.log a montré que les fichiers livrés ont des fins de ligne CRLF et les régénérés LF. Ici : fin de ligne CR
# supprimée en fin de ligne seulement (sed 's/\r$//'), des deux côtés, puis cmp octet par octet ; les sept fichiers.
cd ~/work/z24218418 || exit 1
mkdir -p norm/pkg norm/run
for f in tabla1_conversaciones.csv consensos_polis_tipados.csv lambda_star.csv tipologia_por_conversacion.csv cifras.json cifras_extras.json sensibilidad_paso.json; do
  sed 's/\r$//' pkg/resultados/$f > norm/pkg/$f
  sed 's/\r$//' run/resultados/$f > norm/run/$f
  if cmp -s norm/pkg/$f norm/run/$f; then echo "IDENTIQUE apres normalisation des fins de ligne : $f ($(wc -c < norm/run/$f) octets)"; else echo "DIFFERE : $f"; cmp norm/pkg/$f norm/run/$f; diff norm/pkg/$f norm/run/$f | head -20; fi
done
