#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24353093/telecharge.sh sd-92569:work/
#   bin/capture.sh rapports/zenodo-24353093/telechargement.log 'sh work/telecharge.sh'
# Télécharge sur l'hôte (curl seulement) les fichiers utiles de la fiche 24353093, vérifie leur MD5 (fiche_zenodo.json).
# Les classeurs .xlsx et .docx ne sont pas téléchargés : le script ne peut pas les régénérer (voir RAPPORT.md).
# Rien du paquet n'est exécuté. Les fichiers vont dans pkg/ (original intact, jamais monté en écriture).
B=https://zenodo.org/api/records/24353093/files
rm -rf work/z24353093/pkg work/z24353093/MD5.txt && mkdir -p work/z24353093/pkg
cd work/z24353093 || exit 1
cat > MD5.txt <<'EOF'
a9ecdf66d17e5b7ec6c9519d817461d0  README.md
9c5b838812615ec894e6b689f4e3e5b2  README_Size_Adjusted_PCA_v2.md
72d18b798bf44ed534f10ecd4467f5b0  PCA_UPDATE_CHANGELOG.md
f863135dfea9ed5c8470ca17723ec276  PCA_Caatinga_24_input.csv
600e7c5b4d8fca10739fe681a21aec9d  PCA_Cerrado_75_corrected_input.csv
a213c6898fe2cb6ca29ddf0e77661dc9  run_wchn.py
64f2bb35cb7bd0aef6cc910ea4e4b9db  WCHN_partial_correlations_results.json
f9613aa316d183a9d24e372e2d9a23ff  Reduced_PCA_Cerrado_74_WCHNs.png
cba2f8c39011c124021c692fd6906f7b  Reduced_PCA_Caatinga_24_WCHNs.png
15d06dee020ff77ea02d72ce132c9241  WCHN_Cerrado_PCA_ajustada_SigmaNO.png
cc215afa89d2025a4e1f372ee9ab35ae  WCHN_Cerrado_PCA_ajustada_SigmaNO.svg
d0eef9b022e8007920ae47b2d122d919  WCHN_Caatinga_PCA_ajustada_SigmaNO.png
72ac423ef5510ba9ac91c575eb0e6049  WCHN_Caatinga_PCA_ajustada_SigmaNO.svg
EOF
cd pkg || exit 1
for f in $(cut -c35- ../MD5.txt); do
  curl -sS -f --retry 3 -m 120 -o "$f" "$B/$f/content" || { echo "ECHEC curl $f : $?"; exit 1; }
done
md5sum -c ../MD5.txt
ls -l
