locals {
  postgresql_name = "${lookup(var.specs, "name", local.defaults.boundary_name)}-postgresql"
  postgresql_namespace = "${var.namespace}-postgresql"
  postgresql_connection_string = "postgresql://${local.postgresql_specs.username}:${local.postgresql_specs.password}@${local.postgresql_name}.${local.postgresql_namespace}/${local.postgresql_specs.database}?sslmode=disable"
  postgresql_specs = {
    name = local.postgresql_name
    namespace = local.postgresql_namespace
    storage_class = lookup(var.specs, "postgresql_storage_class", local.defaults.postgresql_storage_class)
    username = lookup(var.specs, "postgresql_username", local.defaults.postgresql_username)
    password = lookup(var.specs, "postgresql_password", local.defaults.postgresql_password)
    database = lookup(var.specs, "name", local.defaults.boundary_name)
  }
}
resource "kubernetes_namespace" "postgresql" {
  
  metadata {
    name = local.postgresql_namespace
  }
}
module "postgresql" {

  depends_on = [kubernetes_namespace.postgresql]

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/postgresql?ref=kubernetes/apps/postgresql-0.1.0"

  namespace = local.postgresql_namespace
  specs = local.postgresql_specs
}