#!/usr/bin/env bash
set -euo pipefail

echo "[i] Applying Kubernetes Job manifests/kubernetes/tf-job.yaml"
kubectl apply -f manifests/kubernetes/tf-job.yaml

echo "[i] Waiting for job completion..."
kubectl wait --for=condition=complete --timeout=1800s job/tf-train || true
kubectl logs job/tf-train --all-containers=true --tail=200
