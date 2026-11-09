#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23647165/telecharge_donnees.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23647165/telechargement_donnees.log 'sh work/telecharge_donnees.sh'
# Télécharge sur l'hôte (curl seulement) les quatre fichiers globaux que le README du paquet demande, depuis
# figshare 25311358 (URL et MD5 de figshare_fiche.json), dans l'arborescence attendue ; vérifie les MD5.
D=work/z23647165/data
rm -rf "$D" && mkdir -p "$D/Fossil fuel EROIs/Global" "$D/Renewable energy EROIs equivalent/Global"
cd "$D" || exit 1
get() { # id md5 dossier nom
  curl -sS -f -L --retry 3 -m 300 -o "$3/$4" "https://ndownloader.figshare.com/files/$1" || { echo "ECHEC curl $4 : $?"; exit 1; }
  echo "$2  $3/$4" > "MD5_$1.txt"
  md5sum -c "MD5_$1.txt" || { echo "MD5 DIFFERENT $4"; exit 1; }
}
get 46240243 c3f330ee874e10aca547d73d76cd3cd2 "Fossil fuel EROIs/Global" global_erois.csv
get 46240237 d0cbb5e69c9ffd03097fcf520d04e14b "Fossil fuel EROIs/Global" global_erois_by_end_use.csv
get 46240258 798fb688c3a54d21a2a58272e69e4b51 "Renewable energy EROIs equivalent/Global" global_erois_equivalent.csv
get 46240261 6689c5bd2f82d86dd6b1768395ed8537 "Renewable energy EROIs equivalent/Global" global_erois_equivalent_by_end_use.csv
find . -type f -name '*.csv'
