# ROLLBACK 🔄

If a cutover fails or SLOs degrade:

1. Revert AML job YAML to the last known good `code:` & `image:` references **or**
2. Reapply the previous Kubernetes manifest using the prior image tag.
3. Confirm recovery with a validation job.
4. Record the incident and lessons learned.
