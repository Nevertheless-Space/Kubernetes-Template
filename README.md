# Kubernetes-Template
Kubernetes as Code Template

## Local Debug
### GitLab/Http Terraform Backend

See [here](/.doc/gitlab-backend.md).

### Terraform minimum variables
```bash
terraform plan --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test

terraform apply --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test

terraform destroy --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test
```