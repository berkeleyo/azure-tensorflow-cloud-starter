# CUTOVER CHECKLIST ✅

- [ ] Image built and scanned; SBOM generated (optional).
- [ ] AML job or K8s manifest updated to use the **release tag** (e.g., `:prod`).
- [ ] Canary run completed, metrics acceptable.
- [ ] RBAC and ACR pull permissions verified for target environment.
- [ ] Observability dashboards updated (logs/metrics).
- [ ] Runbook and README version bumped; changelog entry created.
