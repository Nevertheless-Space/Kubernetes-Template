$boundary_host="http://20.93.25.25:9200/"
$boundary_username="admin"
$boundary_password="password"
$boundary_auth_method="ampw_b1XMY4YBfM"

boundary authenticate password -addr $boundary_host -login-name $boundary_username -auth-method-id $boundary_auth_method -password $boundary_password


$job1 = start-job -ScriptBlock {
param($boundary_host)
boundary connect -target-name="nginx-01" -target-scope-name="generic_apps" -addr $boundary_host -listen-port 81
} -ArgumentList $boundary_host

$job2 = start-job -ScriptBlock {
param($boundary_host)
boundary connect -target-name="nginx-02" -target-scope-name="generic_apps" -addr $boundary_host -listen-port 82
} -ArgumentList $boundary_host

#Wait for jobs to finish
# Get-Job | Wait-Job

Read-Host

#Output results
Receive-Job $job1
Receive-Job $job2

#Clean up jobs
remove-job $job1.id -Force
remove-job $job2.id -Force