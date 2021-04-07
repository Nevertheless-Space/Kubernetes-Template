## Usage Example

The commented fields are optional.

```bash
module "generic-apps" {

  source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/apps/generic"
  
  namespace = "nginx"
  apps = [{
    # replicas = 1
    name = "nginx"
    image = "nginx"
    # container_port = 80
    # service_port = 80
    # service_type = "ClusterIP"
    # labels = {}
    # resources = {
    #   limits = {
    #     cpu    = "0.5"
    #     memory = "512Mi"
    #   }
    #   requests = {
    #     cpu    = "250m"
    #     memory = "50Mi"
    #   }
    # }
    # config_map = {
    #   mount_path = "/usr/share/nginx/html"
    #   data = {
    #     "index.html" = "${file("./assets/nginx-01/index.html")}"
    #   }
    #   # binary_data = {}
    # }
    # ingress = {
    #   ingress_class = "nginx-test"
    #   # hostname = ""
    #   # path = "/"
    #   # annotations = {}
    #   # tls = {
    #   #   hosts = []
    #   #   secret_name = "test-cert"
    #   # }
    # }
  }]
}
```