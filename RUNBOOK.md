# RUNBOOK – Azure TensorFlow Cloud Starter 🧰

This runbook is the minimal, **operator-focused** guide to build, push, and execute a TensorFlow job on Azure via **Azure ML** or **AKS**.

---

## 0) Prereqs

- Azure CLI installed and authenticated (`az login`).
- Sufficient permissions to create RG/ACR/AKS/AML.
- Docker engine available for local builds (or use Azure Build Tasks).
- `kubectl` configured if using AKS.

---

## 1) Configure variables

Edit `configs/sample.env` (copy to `.env` for your own use; do not commit secrets):

```
SUBSCRIPTION_ID=<SUBSCRIPTION_ID>
LOCATION=uksouth
RESOURCE_GROUP=rg-ml-demo
ACR_NAME=acrml<unique>
AKS_NAME=aks-ml-demo
AML_WS=mlw-ml-demo
AML_RG=${RESOURCE_GROUP}
IMAGE_NAME=tf-train
IMAGE_TAG=0.1.0
```

Export into your session:

```bash
set -a && source ./configs/sample.env && set +a
```

---

## 2) Provision core resources

- **ACR + AKS**: `./scripts/azure/create-acr-aks.sh`
- (Optional) Add AML workspace later from Portal or via CLI.

---

## 3) Build & push the image

`./scripts/docker_build_and_push.sh`

The image will be pushed as: `$(az acr show -n $ACR_NAME --query loginServer -o tsv)/$IMAGE_NAME:$IMAGE_TAG`

---

## 4) Execute a job

### Option A – Azure ML

1. Ensure ML extension: `az extension add -n ml -y`
2. Submit: `./scripts/azureml/submit-job.sh`
3. View run: `az ml job show --name <JOB_ID> --web`

### Option B – AKS (Kubernetes Job)

1. Ensure `kubectl` context points to your AKS: `az aks get-credentials -g $RESOURCE_GROUP -n $AKS_NAME`
2. Submit: `./scripts/kubernetes/submit-job.sh`
3. Logs: `kubectl logs job/tf-train -f`

---

## 5) Promote (Cutover)

- Tag image as `:prod` (immutable tag policy recommended).
- Update AML job YAML or K8s manifest to use `:prod`.
- Record promotion in `docs/CUTOVER_CHECKLIST.md`.

---

## 6) Rollback

- Re-point to previous `IMAGE_TAG` or AML job `job_uri`.
- See `docs/ROLLBACK.md` for atomic steps.

---

## 7) Hygiene

- No secrets in git. Use **Key Vault**, **Managed Identity**, or AML Secrets.
- Rotate credentials regularly.
- Keep clusters and agents patched.

---

## 8) Troubleshooting

- Auth issues: verify `az account show` and role assignments.
- Image pull errors: confirm ACR permissions on AKS/AML.
- Node resource limits: adjust SKU or requests/limits in the manifest.
