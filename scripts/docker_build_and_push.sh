#!/usr/bin/env bash
set -euo pipefail

if [ -f "./configs/sample.env" ]; then
  set -a; source ./configs/sample.env; set +a
fi

: "${RESOURCE_GROUP:?}"
: "${ACR_NAME:?}"
: "${IMAGE_NAME:?}"
: "${IMAGE_TAG:?}"
: "${DOCKERFILE:=Dockerfile}"

LOGIN_SERVER=$(az acr show -n "$ACR_NAME" --query loginServer -o tsv)
IMAGE="${LOGIN_SERVER}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "[i] Building image $IMAGE"
docker build -f "$DOCKERFILE" -t "$IMAGE" .

echo "[i] Logging in to ACR"
az acr login -n "$ACR_NAME" >/dev/null

echo "[i] Pushing image"
docker push "$IMAGE"

echo "[✔] Pushed $IMAGE"
