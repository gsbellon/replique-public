#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-23585999/telecharge_extrait.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-23585999/telechargement.log 'sh work/telecharge_extrait.sh'
# Télécharge sur l'hôte (curl seulement) les trois ZIP numérotés et ARTIFACT_HASHES.json depuis Zenodo, vérifie les MD5 de la fiche
# (fiche_zenodo.json), extrait dans un dossier vide pkg/ avec python -I (aucun code du paquet n'est exécuté).
B=https://zenodo.org/api/records/23585999/files
rm -rf work/z23585999 && mkdir -p work/z23585999/dl work/z23585999/pkg
cd work/z23585999/dl || exit 1
for f in ARTIFACT_HASHES.json 306_Replication_v0024_1_scientific.zip 306_Replication_v0024_2_SCF2022.zip 306_Replication_v0024_3_SCF2025.zip; do
  curl -sS -f --retry 3 -m 300 -o "$f" "$B/$f/content" || { echo "ECHEC curl $f : $?"; exit 1; }
done
cat > MD5.txt <<EOF
14452ccd87b9be7c922cbbd301eaa758  306_Replication_v0024_1_scientific.zip
7680de8b6314a5d01a30ed4992480ac2  306_Replication_v0024_2_SCF2022.zip
4789bee7c0f0566b29c9591a3adf5c7c  306_Replication_v0024_3_SCF2025.zip
c5196eebb67a6a87da425d23ce80eb8b  ARTIFACT_HASHES.json
EOF
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cat ARTIFACT_HASHES.json
cd ../pkg || exit 1
for z in ../dl/306_Replication_v0024_1_scientific.zip ../dl/306_Replication_v0024_2_SCF2022.zip ../dl/306_Replication_v0024_3_SCF2025.zip; do
  python3 -I -c "import sys, zipfile; zipfile.ZipFile(sys.argv[1]).extractall('.')" "$z"
  echo "code extraction $z : $?"
done
find . -type f | wc -l
find . -maxdepth 2
