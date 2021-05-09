provider "boundary" {
  addr             = "http://20.93.25.25:9200"
  recovery_kms_hcl = file("./assets/boundary/kms_recovery.hcl")
}
resource "boundary_scope" "org" {

  depends_on = [module.boundary]

  scope_id    = "global"
  name        = "organization"
  description = "Organization scope"

  auto_create_admin_role   = false
  auto_create_default_role = false
}
resource "boundary_role" "global_anon_listing" {
  scope_id = "global"
  grant_strings = [
    "id=*;type=*;actions=*"
    # "id=*;type=auth-method;actions=list,authenticate",
    # "type=scope;actions=list",
    # "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}
resource "boundary_role" "org_anon_listing" {
  scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

resource "boundary_auth_method" "password" {
  scope_id = boundary_scope.org.id
  type     = "password"
}

resource "boundary_account" "admin_user" {
  auth_method_id = boundary_auth_method.password.id
  type           = "password"
  login_name     = "admin"
  password       = "password"
}

resource "boundary_user" "admin_user" {
  name        = "admin_user"
  description = "admin_user"
  account_ids = [boundary_account.admin_user.id]
  scope_id    = boundary_scope.org.id
}

resource "boundary_role" "org_admin" {
  scope_id       = "global"
  grant_scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.admin_user.id]
}




resource "boundary_scope" "project_test" {
  name                   = "generic_apps"
  description            = "generic_apps"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}
resource "boundary_role" "project_test_admin" {
  scope_id       = boundary_scope.org.id
  grant_scope_id = boundary_scope.project_test.id
  grant_strings = [
    "id=*;type=*;actions=*"
  ]
  principal_ids = [boundary_user.admin_user.id]
}

resource "boundary_host_catalog" "nginx" {
  name        = "nginx"
  description = "nginx catalog"
  scope_id    = boundary_scope.project_test.id
  type        = "static"
}

resource "boundary_host" "nginx_01" {
  name            = "nginx_01"
  type            = "static"
  host_catalog_id = boundary_host_catalog.nginx.id
  # scope_id        = boundary_scope.project_test.id
  address         = "nginx-01.apps"
}

resource "boundary_host" "nginx_02" {
  name            = "nginx_02"
  type            = "static"
  host_catalog_id = boundary_host_catalog.nginx.id
  # scope_id        = boundary_scope.project_test.id
  address         = "nginx-02.apps"
}

resource "boundary_host_set" "nginx_01" {
  name            = "nginx-01"
  type            = "static"
  host_catalog_id = boundary_host_catalog.nginx.id

  host_ids = [
    boundary_host.nginx_01.id,
  ]
}
resource "boundary_host_set" "nginx_02" {
  name            = "nginx-02"
  type            = "static"
  host_catalog_id = boundary_host_catalog.nginx.id

  host_ids = [
    boundary_host.nginx_02.id,
  ]
}

resource "boundary_target" "nginx_01" {
  name         = "nginx-01"
  type         = "tcp"
  description  = "nginx target"
  default_port = "80"
  scope_id     = boundary_scope.project_test.id
  host_set_ids = [
    boundary_host_set.nginx_01.id
  ]
}
resource "boundary_target" "nginx_02" {
  name         = "nginx-02"
  type         = "tcp"
  description  = "nginx target"
  default_port = "80"
  scope_id     = boundary_scope.project_test.id
  host_set_ids = [
    boundary_host_set.nginx_02.id
  ]
}