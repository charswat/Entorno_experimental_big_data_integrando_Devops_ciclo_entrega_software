#!/usr/bin/env bash

source ~/.profile

if [ -z "$EMAIL" ] || [ -z "$NAME" ]|| [ -z "$TOKEN" ]||[ -z "$REPOSITORY" ]; then
    echo "[error] parámetros must be defined." >&2
    exit 1
fi
 #config git
 cd /home/ubuntu
 git config --global user.name "$NAME"
 git config --global user.email "$EMAIL"
 git config --local --unset credential.helper
 git config --global --unset credential.helper "cache --timeout=86400"
 git config --global user.password $TOKEN
 #clonar repositorio
 git clone $REPOSITORY Versionado
 cd Versionado
 git remote set-url origin $REPOSITORY
 sudo mkdir -p .github/workflows
 sudo mv /home/ubuntu/build.yml /home/ubuntu/Versionado/.github/workflows/build.yml
 sudo mv /home/ubuntu/sonar-project.properties /home/ubuntu/Versionado/sonar-project.properties



