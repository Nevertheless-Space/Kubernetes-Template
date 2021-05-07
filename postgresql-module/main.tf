# https://github.com/bitnami/charts/tree/master/bitnami/postgresql
resource "helm_release" "postgresql" {

  name       = lookup(var.specs, "name", "postgresql")
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = var.chart_version
  namespace  = var.namespace
  timeout    = var.helm_timeout

  set {
    name  = "global.postgresql.postgresqlUsername"
    value = lookup(var.specs, "username", "postgresql")
  }
  set {
    name  = "global.postgresql.postgresqlPassword"
    value = lookup(var.specs, "password", "postgresql")
  }
  set {
    name  = "global.postgresql.postgresqlDatabase"
    value = lookup(var.specs, "database", "postgresql")
  }
  set {
    name  = "global.storageClass"
    value = lookup(var.specs, "storage_class", "default")
  }

  # ------------------------------ Other Configurations ------------------------------ #
  dynamic "set" {
    for_each = lookup(var.specs, "other_configurations", null) == null ? [] : var.specs.other_configurations
    content {
      name  = set.value.name
      value = set.value.value
    }
  }
}