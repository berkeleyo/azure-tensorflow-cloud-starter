#!/usr/bin/env bash
set -euo pipefail

if [ -f "./configs/sample.env" ]; then
  set -a; source ./configs/sample.env; set +a
fi

: "${AML_RG:?}"
: "${AML_WS:?}"

echo "[i] Submitting Azure ML job using manifests/azureml/tf-train-job.yml"
az ml job create --file manifests/azureml/tf-train-job.yml -g "$AML_RG" -w "$AML_WS"
