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
  }
}