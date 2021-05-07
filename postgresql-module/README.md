postgresql_specs = {
    name = "postgresql"
    chart_version = "10.4.2"

    namespace = "postgresql"

    username = "postgres"
    password = "postgres"
    storage_class = "default"

    other_configurations = {
      "key": "value"
    }
  }