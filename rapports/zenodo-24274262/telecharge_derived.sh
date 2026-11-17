#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/telecharge_derived.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24274262/telechargement_derived.log 'sh work/telecharge_derived.sh'
# Télécharge sur l'hôte (curl seulement) derived.tar.gz, SHA256SUMS, experiment_config.yaml et README.md de la fiche
# Zenodo 23799274 (données liées par le paquet), vérifie les MD5 de la fiche (fichiers_donnees.json), extrait
# derived.tar.gz avec python -I dans un dossier vide (aucun code du paquet n'est exécuté).
B=https://zenodo.org/api/records/23799274/files
rm -rf work/z24274262/data && mkdir -p work/z24274262/data/dl work/z24274262/data/derived
cd work/z24274262/data/dl || exit 1
for f in derived.tar.gz SHA256SUMS experiment_config.yaml README.md; do
  curl -sS -f --retry 3 -m 600 -o "$f" "$B/$f/content" || { echo "ECHEC curl $f : $?"; exit 1; }
done
cat > MD5.txt <<EOF
df07af4a72213e8c75123eb5822f7b95  derived.tar.gz
39b73719166af7e91f78345d7c2e52d4  SHA256SUMS
294ccf2e7e8c755f3544d2894e5ad8bc  experiment_config.yaml
f7fa052401e57d63910440e84d4f00cd  README.md
EOF
md5sum -c MD5.txt || { echo "MD5 DIFFERENT"; exit 1; }
cd ../derived || exit 1
python3 -I -c "import sys, tarfile; tarfile.open(sys.argv[1]).extractall('.', filter='data')" ../dl/derived.tar.gz
echo "code extraction : $?"
find . -type f | wc -l
find . -maxdepth 2 | head -40
du -sh .
