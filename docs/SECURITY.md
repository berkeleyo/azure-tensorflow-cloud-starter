# SECURITY 🛡️

- **No secrets in git**. Use Key Vault, AML secrets, or Managed Identity.
- **Least privilege** role assignments (ACR Pull, Contributor as needed).
- **Private networking** (ACR private endpoints, AKS private cluster) where possible.
- **Image signing & policy** (content trust, tag immutability).
- **Vulnerability scanning** on container images.
- **Quotas & limits** – enforce GPU/CPU limits, requests in K8s manifests.
- **Audit** – enable diagnostics on AKS/AML and ACR.
