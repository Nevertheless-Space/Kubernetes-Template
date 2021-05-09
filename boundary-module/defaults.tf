locals {
  defaults = {
    boundary_name = "boundary"
    boundary_version = "0.1.8"
    boundary_init_default_mode = true
    boundary_service_type = "ClusterIP"
    boundary_ingress_class = "nginx"
    postgresql_username = "postgres"
    postgresql_password = "postgres"
    postgresql_storage_class = "default"
  }
}