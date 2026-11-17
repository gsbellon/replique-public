#!/bin/sh
# Ligne d'appel (depuis le pilote, à la racine du dépôt) :
#   scp rapports/zenodo-24274262/lance_build.sh rapports/zenodo-24274262/Containerfile sd-92569:work/z24274262/
#   bin/capture.sh rapports/zenodo-24274262/build.log 'cd ~/work/z24274262 && sh lance_build.sh'
# Contexte de construction = build/ : Containerfile et trois fichiers de configuration du paquet (aucun code du paquet
# n'est exécuté sur l'hôte). Archive l'image et relève son empreinte.
P=pkg/gialmisi-shadow-price-experiments-22691ed
rm -rf build && mkdir build
cp Containerfile build/
cp $P/pyproject.toml $P/uv.lock $P/.python-version build/
podman build -t replab-shadow -f build/Containerfile build
echo "code de sortie build : $?"
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only replab-shadow /app/.venv/bin/python --version
podman run --rm --network none --cap-drop all --security-opt no-new-privileges --read-only --tmpfs /tmp -e UV_CACHE_DIR=/tmp/uvcache replab-shadow uv pip freeze --python /app/.venv/bin/python
mkdir -p ~/images
rm -f ~/images/zenodo-24274262.tar
podman save -o ~/images/zenodo-24274262.tar localhost/replab-shadow
echo "code de sortie save : $?"
sha256sum ~/images/zenodo-24274262.tar
podman image inspect --format '{{.Id}}' localhost/replab-shadow
