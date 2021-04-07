terraform {
  required_version = ">= 0.12.20"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.3"
    }
  }
}