terraform {
  required_version = ">= 0.14.9"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.3"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }
}