# Kubernetes-Template
Kubernetes as Code Template

## Local Debug
### GitLab/Http Terraform Backend

See [here](/.doc/gitlab-backend.md).

### Terraform minimum variables
```bash
terraform plan --var account_azure_subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_secret=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test --var k8s_cluster_aks_version=X.XX.XX

terraform apply --var account_azure_subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_secret=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test --var k8s_cluster_aks_version=X.XX.XX

terraform destroy --var account_azure_subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_id=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_client_secret=XXXXXXXXXXXXXXXXXXXXXX --var account_azure_tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test --var k8s_cluster_aks_version=X.XX.XX
```