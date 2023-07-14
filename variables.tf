variable "region" {
  description = "Value of the 'Region' of the OCI instance"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "region_oke" {
  description = "Value of the 'Region' of the OCI instance"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "tenancy_ocid" {
  description = "Value of the root Compartment OCID"
  type        = string
  sensitive   = true
}

variable "user_ocid" {
  description = "Value of the User OCID"
  type        = string
  sensitive   = true
}

variable "user_rsa_path" {
  description = "Value of the path to the RSA Private Key"
  type        = string
  sensitive   = true
}

variable "user_rsa_fingerprint" {
  description = "Value of the fingerprint of the RSA Public Key"
  type        = string
  sensitive   = true
}

variable "oke_version" {
  description = "Value of the OKE version"
  type        = string
  default     = "v1.26.2"
  sensitive   = true
}
