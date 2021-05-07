locals {
  postgresql_name = "${lookup(var.specs, "name", "boundary")}-postgresql"
  postgresql_namespace = "${var.namespace}-postgresql"
  postgresql_connection_string = "postgresql://${local.postgresql_specs.username}:${local.postgresql_specs.password}@${local.postgresql_name}.${local.postgresql_namespace}/${local.postgresql_specs.database}?sslmode=disable"
  postgresql_specs = {
    name = local.postgresql_name
    namespace = local.postgresql_namespace
    storage_class = lookup(var.specs, "storage_class", "default")
    username = lookup(var.specs, "username", "postgres")
    password = lookup(var.specs, "password", "postgres")
    database = "boundary"
  }
}
resource "kubernetes_namespace" "postgresql" {
  
  metadata {
    name = local.postgresql_namespace
  }
}
module "postgresql" {

  depends_on = [kubernetes_namespace.postgresql]

  source = "../postgresql-module"

  namespace = local.postgresql_namespace
  specs = local.postgresql_specs
}