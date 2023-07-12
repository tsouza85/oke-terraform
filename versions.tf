terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.96.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13.0"
    }

    k8s = {
      source  = "banzaicloud/k8s"
      version = ">= 0.8.0"
    }
  }
}