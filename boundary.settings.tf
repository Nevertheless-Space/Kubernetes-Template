# provider "boundary" {
#   addr             = "http://52.156.204.57"
#   recovery_kms_hcl = file("./boundary.recovery.hcl")
# }
# resource "boundary_scope" "org" {
#   scope_id    = "global"
#   name        = "organization"
#   description = "Organization scope"

#   auto_create_admin_role   = false
#   auto_create_default_role = false
# }
# resource "boundary_scope" "project" {
#   name                     = "project"
#   description              = "My first project"
#   scope_id                 = boundary_scope.org.id
#   auto_create_admin_role   = false
#   auto_create_default_role = false
# }
# resource "boundary_auth_method" "password" {
#   name        = "my_password_auth_method"
#   description = "Password auth method"
#   type        = "password"
#   # scope_id    = boundary_scope.org.id
#   scope_id    = "global"
# }
# resource "boundary_account" "myuser" {
#   name           = "myuser"
#   description    = "User account for my user"
#   type           = "password"
#   login_name     = "myuser"
#   password       = "foofoofoo"
#   auth_method_id = boundary_auth_method.password.id
# }
# resource "boundary_user" "myuser" {
#   name        = "myuser"
#   description = "My user!"
#   account_ids = [boundary_account.myuser.id]
#   scope_id    = boundary_scope.org.id
# }
# resource "boundary_role" "global_anon_listing" {
#   scope_id = "global"
#   grant_strings = [
#     "id=*;type=auth-method;actions=list,authenticate",
#     "type=scope;actions=list",
#     "id={{account.id}};actions=read,change-password"
#   ]
#   principal_ids = ["u_anon"]
# }
# resource "boundary_role" "org_anon_listing" {
#   scope_id = boundary_scope.org.id
#   grant_strings = [
#     "id=*;type=auth-method;actions=list,authenticate",
#     "type=scope;actions=list",
#     "id={{account.id}};actions=read,change-password"
#   ]
#   principal_ids = ["u_anon"]
# }
# resource "boundary_role" "org_admin" {
#   scope_id       = "global"
#   grant_scope_id = boundary_scope.org.id
#   grant_strings = [
#     "id=*;type=*;actions=*"
#   ]
#   principal_ids = [boundary_user.myuser.id]
# }
# resource "boundary_role" "project_admin" {
#   scope_id       = boundary_scope.org.id
#   grant_scope_id = boundary_scope.project.id
#   grant_strings = [
#     "id=*;type=*;actions=*"
#   ]
#   principal_ids = [boundary_user.myuser.id]
# }