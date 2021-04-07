# GitLab Terraform Backend for local testing 

## Variables

### Powershell
``` powershell
$username = "<GitLab Username>"
$password = "<GitLab Personal Access Token>"
$project_id = "<GitLab Project ID>"
$tfstate_name = "<Gitlab Project Name>"
```

### Bash
``` bash
username="<GitLab Username>"
password="<GitLab Personal Access Token>"
project_id="<GitLab Project ID>"
tfstate_name="<Gitlab Project Name>"
```

## Code

### Powershell
``` powershell
terraform init `
    -backend-config="address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name" `
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" `
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" `
    -backend-config="username=$username" `
    -backend-config="password=$password" `
    -backend-config="lock_method=POST" `
    -backend-config="unlock_method=DELETE" `
    -backend-config="retry_wait_min=5"

terraform apply --var subscription_id=XXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXX --var tenant=k8s-template --var env=test
```

### Bash
``` bash
terraform init \
    -backend-config="address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name" \
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" \
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/$project_id/terraform/state/$tfstate_name/lock" \
    -backend-config="username=$username" \
    -backend-config="password=$password" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"

terraform apply --var subscription_id=XXXXXXXXXXXXXXXX --var client_id=XXXXXXXXXXXXXXXX --var client_secret=XXXXXXXXXXXXXXXX --var tenant_id=XXXXXXXXXXXXXXXX --var tenant=k8s-template --var env=test
```