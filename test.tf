# # module "generic-jobs" {

# #   providers = {
# #     kubernetes = kubernetes.default
# #   }

# #   source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/jobs/generic?ref=test"
  
# #   namespace = "default"
# #   jobs = [
# #     {
# #       name = "test1"
# #       image = "ubuntu"
# #       args = ["echo \"$(cat /tmp/script.sh)\" > /home/script.sh; cd /home; chmod +x ./script.sh; ./script.sh"]
# #       command = ["bash", "-c"]
# #       config_map = {
# #         mount_path = "/tmp"
# #         data = {
# #           "script.sh" = "${file("./assets/test.sh")}"
# #         }
# #       }
# #     }
# #   ]
# # }

# module "generic-jobs-1" {

#   providers = {
#     kubernetes = kubernetes.default
#   }

#   source = "git::https://github.com/nevertheless-space/terraform-modules//kubernetes/jobs/bash?ref=test"
  
#   namespace = "default"
#   specs = [{
#     name = "test"
#     commands = "echo \"prova1\"; dir; cd /etc; dir"
#     wait_for_completion = true
#     completion_timeout = 300 # seconds
#   },
#   {
#     name = "test2"
#     commands = "${file("./assets/test.sh")}"
#     wait_for_completion = true
#     completion_timeout = 300 # seconds
#   }]
# }