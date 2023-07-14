################################################################################
# Provider
################################################################################
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.user_rsa_path
  fingerprint      = var.user_rsa_fingerprint
}

provider "kubernetes" {
  config_path = "${path.module}/generated/kubeconfig"
}

################################################################################
# Compartment
################################################################################

resource "oci_identity_compartment" "k8s" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for Free Tier K8s Cluster"
  name           = "OracleManagedKubernetesCompartment"
}

################################################################################
# OKE
################################################################################

module "oke" {
  source = "oracle-terraform-modules/oke/oci"

  compartment_id = oci_identity_compartment.k8s.id

  home_region                 = var.region
  region                      = var.region_oke
  tenancy_id                  = var.tenancy_ocid
  create_operator             = false
  create_bastion_host         = false
  control_plane_type          = "public"
  control_plane_allowed_cidrs = ["0.0.0.0/0"]
  kubernetes_version          = var.oke_version
  node_pools = {
    np1 = {
      boot_volume_size = 100
      node_pool_size   = 2
      ocpus            = 2
      shape            = "VM.Standard.A1.Flex"
      memory           = 12
    }
  }
  providers = {
    oci.home = oci
  }
}