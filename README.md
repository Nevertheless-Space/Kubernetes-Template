# Kubernetes-Template
Kubernetes as Code Template

## Local Debug
### GitLab/Http Terraform Backend

```powershell
$username = "XXXXXXXXXX"
$password = "XXXXXXXXXXXXXXX"
$project_id = "XXXXXXXXX"
$tfstate_name = "<PROJECT-NAME>"

terraform init `
    -backend-config="address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name" `
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" `
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" `
    -backend-config="username=$username" `
    -backend-config="password=$password" `
    -backend-config="lock_method=POST" `
    -backend-config="unlock_method=DELETE" `
    -backend-config="retry_wait_min=5"
```

### Terraform minimum variables
```bash
terraform plan --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test

terraform apply --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test

terraform destroy --var subscription_id=XXXXXXXXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXXXXXXXX --var tenant=example --var env=test
```