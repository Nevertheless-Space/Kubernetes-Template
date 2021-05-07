# This is a default configuration provided for our Docker image. It's meant to
# be a starting point and to help new users get started. It's strongly
# recommended that this configuration is not used outside of demonstrations
# because it uses hard coded AEAD keys.

disable_mlock = true

controller {
  name = "demo-controller"
  description = "A default controller created for demonstration"

  database {
    # This configuration setting requires the user to execute the container with the URL as an env var
    # to connect to the Boundary postgres DB. An example of how this can be done assuming the postgres
    # database is running as a container and you're using Docker for Mac (replace host.docker.internal with
    # localhost if you're on Linux):
    #
    #    $  docker run -e 'BOUNDARY_POSTGRES_URL=postgresql://postgres:postgres@host.docker.internal:5432/postgres?sslmode=disable' [other options] boundary:[version]
    url = "env://BOUNDARY_POSTGRES_URL"
  }

  public_cluster_addr = "env://HOSTNAME"
}

worker {
  name = "demo-worker"
  description = "A default worker created for demonstration"
}

listener "tcp" {
  address = "0.0.0.0"
  purpose = "api"
  tls_disable = true
}

listener "tcp" {
  address = "0.0.0.0"
  purpose = "cluster"
  tls_disable   = true
}

listener "tcp" {
  address = "0.0.0.0"
  purpose       = "proxy"
  tls_disable   = true
}

kms "aead" {
    purpose   = "root"
    aead_type = "aes-gcm"
    key       = "sP1fnF5Xz85RrXyELHFeZg9Ad2qt4Z4bgNHVGtD6ung="
    key_id    = "global_root"
}

kms "aead" {
    purpose   = "worker-auth"
    aead_type = "aes-gcm"
    key       = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id    = "global_worker-auth"
}

kms "aead" {
    purpose   = "recovery"
    aead_type = "aes-gcm"
    key       = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
    key_id    = "global_recovery"
}