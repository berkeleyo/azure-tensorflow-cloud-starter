#!/usr/bin/env bash
set -euo pipefail

# Load variables
if [ -f "./configs/sample.env" ]; then
  set -a; source ./configs/sample.env; set +a
fi

: "${SUBSCRIPTION_ID:?}"
: "${LOCATION:?}"
: "${RESOURCE_GROUP:?}"
: "${ACR_NAME:?}"
: "${AKS_NAME:?}"

echo "[i] Using subscription: ${SUBSCRIPTION_ID}"
az account set --subscription "${SUBSCRIPTION_ID}"

echo "[i] Creating resource group ${RESOURCE_GROUP} in ${LOCATION}"
az group create -n "${RESOURCE_GROUP}" -l "${LOCATION}" -o none

echo "[i] Creating ACR ${ACR_NAME} (Premium recommended for prod)"
az acr create -g "${RESOURCE_GROUP}" -n "${ACR_NAME}" --sku Standard -o none

echo "[i] Creating AKS ${AKS_NAME}"
az aks create -g "${RESOURCE_GROUP}" -n "${AKS_NAME}" --node-count 1 --generate-ssh-keys -o none

echo "[i] Attaching ACR to AKS"
az aks update -g "${RESOURCE_GROUP}" -n "${AKS_NAME}" --attach-acr "${ACR_NAME}" -o none

echo "[i] Getting kubectl credentials"
az aks get-credentials -g "${RESOURCE_GROUP}" -n "${AKS_NAME}" --overwrite-existing -o none

echo "[✔] ACR + AKS ready."
