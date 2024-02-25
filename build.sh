#!/usr/bin/env bash
if [ ! -f melange.rsa ]
then
    docker run --rm -v "${PWD}":/work cgr.dev/chainguard/melange keygen
fi
sudo docker run --privileged --rm --workdir /work -v "${PWD}":/work \
  cgr.dev/chainguard/melange build py3-uv.yaml \
  --arch host \
  --signing-key melange.rsa
sudo docker run --rm --workdir /work -v "${PWD}":/work \
  cgr.dev/chainguard/apko build builder-image-config.yaml \
  alpine-python-uv:test alpine-python-uv.tar \
  --arch host \
  -k melange.rsa.pub
sudo docker load < alpine-python-uv.tar
sudo docker build --tag 'apko-alpine-py-uv-fastapi' .
echo 'You now have a Docker image available tagged with "apko-alpine-py-uv-fastapi"'
