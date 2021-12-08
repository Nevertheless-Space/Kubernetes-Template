terraform {
  backend "http" {
  }
  required_version = ">= 0.14.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.52.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.0.3"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.0.3"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.13"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
  }
}