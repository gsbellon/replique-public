#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23624408/telecharge_ibge.sh sd-92569:work/z23624408/
#   bin/capture.sh rapports/zenodo-23624408/telechargement_ibge.log 'cd ~/work/z23624408 && sh telecharge_ibge.sh'
# Télécharge sur l'hôte, avec curl seulement, les fichiers que R/01_download.R téléchargerait (mêmes URL,
# liste de R/01_download.R). Aucun code du paquet n'est exécuté. Les fichiers déjà présents ne sont pas retéléchargés.
B10=https://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_Gerais_da_Amostra/Microdados/
U22=https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Microdados_e_Areas_de_Ponderacao/Microdados_de_acesso_Publico/csv/Todas_as_UFs.zip
mkdir -p raw/census2010 raw/census2022
for f in AC AL AM AP BA CE DF ES GO MA MG MS MT PA PB PE PI PR RJ RN RO RR RS SC SE SP1 SP2_RM TO Documentacao; do
  [ -f raw/census2010/$f.zip ] || curl -sS -f -m 900 -o raw/census2010/$f.zip "$B10$f.zip"
  echo "$f code=$?"
done
[ -f raw/census2022/Todas_as_UFs.zip ] || curl -sS -f -m 1800 -o raw/census2022/Todas_as_UFs.zip "$U22"
echo "2022 code=$?"
ls -l raw/census2010 raw/census2022
