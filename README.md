# Oracle OKE Terraform

This repository contains the **Terraform** scripts to bootstrap a Kubernetes Cluster in the **Oracle Cloud Infrastructure Free Tier** with **Oracle Kubernetes Engine (OKE)**.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.13.0 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | >= 4.96.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 5.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_oke"></a> [oke](#module\_oke) | oracle-terraform-modules/oke/oci | n/a |

## Resources

| Name | Type |
|------|------|
| [oci_identity_compartment.k8s](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment) | resource |
| [oci_containerengine_cluster_kube_config.kube_config](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_cluster_kube_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oke_version"></a> [oke\_version](#input\_oke\_version) | Value of the OKE version | `string` | `"v1.26.2"` | no |
| <a name="input_region"></a> [region](#input\_region) | Value of the 'home Region' | `string` | `"sa-saopaulo-1"` | no |
| <a name="input_region_oke"></a> [region\_oke](#input\_region\_oke) | Value of the 'Region' of the OKE Cluster | `string` | `"sa-saopaulo-1"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Value of the root Compartment OCID | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | Value of the User OCID | `string` | n/a | yes |
| <a name="input_user_rsa_fingerprint"></a> [user\_rsa\_fingerprint](#input\_user\_rsa\_fingerprint) | Value of the fingerprint of the RSA Public Key | `string` | n/a | yes |
| <a name="input_user_rsa_path"></a> [user\_rsa\_path](#input\_user\_rsa\_path) | Value of the path to the RSA Private Key | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | Public IP address of Bastion host |
| <a name="output_bastion_service_instance_ocid"></a> [bastion\_service\_instance\_ocid](#output\_bastion\_service\_instance\_ocid) | OCID for the Bastion service |
| <a name="output_cluster_ocid"></a> [cluster\_ocid](#output\_cluster\_ocid) | OCID for the Kubernetes cluster |
| <a name="output_ig_route_ocid"></a> [ig\_route\_ocid](#output\_ig\_route\_ocid) | OCID for the route table of the VCN Internet Gateway |
| <a name="output_internal_lb_nsg_ocid"></a> [internal\_lb\_nsg\_ocid](#output\_internal\_lb\_nsg\_ocid) | OCID of default NSG that can be associated with the internal load balancer |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Convenient command to set KUBECONFIG environment variable before running kubectl locally |
| <a name="output_nat_route_ocid"></a> [nat\_route\_ocid](#output\_nat\_route\_ocid) | OCID of route table to NAT Gateway attached to VCN |
| <a name="output_nodepool_ocids"></a> [nodepool\_ocids](#output\_nodepool\_ocids) | Map of Nodepool names and OCIDs |
| <a name="output_operator_private_ip"></a> [operator\_private\_ip](#output\_operator\_private\_ip) | Private IP address of Operator host |
| <a name="output_public_lb_nsg_ocid"></a> [public\_lb\_nsg\_ocid](#output\_public\_lb\_nsg\_ocid) | OCID of default NSG that can be associated with the internal load balancer |
| <a name="output_ssh_to_bastion"></a> [ssh\_to\_bastion](#output\_ssh\_to\_bastion) | Convenient command to SSH to the Bastion host |
| <a name="output_ssh_to_operator"></a> [ssh\_to\_operator](#output\_ssh\_to\_operator) | Convenient command to SSH to the Operator host |
| <a name="output_subnet_ocids"></a> [subnet\_ocids](#output\_subnet\_ocids) | Map of subnet OCIDs (worker, int\_lb, pub\_lb) used by OKE |
| <a name="output_vcn_ocid"></a> [vcn\_ocid](#output\_vcn\_ocid) | OCID of VCN where OKE is created. Use this VCN OCID to add more resources. |


### Oracle Cloud Infrastructure (OCI) Access

In order to be able to perform operations against OCI, we need to create and import an RSA Key for API signing.

This can be easily performed with the following steps:

1. Make an `.oci` directory on your home folder:

```shell
$ mkdir ~/.oci
```

2. Generate a 2048-bit private key in a PEM format:

```shell
$ openssl genrsa -out ~/.oci/oci_api_key.pem 2048
```

3. Change permissions, so only you can read and write to the private key file:

```shell
$ chmod 600 ~/.oci/oci_api_key.pem
```

4. Generate the public key:

```shell
$ openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
$ cat ~/.oci/oci_api_key_public.pem | pbcopy
```

5. Add the public key to your OCI user account from `User Settings > API Keys`

### Oracle Cloud Infrastructure (OCI) CLI

We need a correctly configured OCI CLI to log against our to-be-created Kubernetes Cluster, as we will use the K8s login plugin to get a JWT for access.

Instructions on how to install the OCI CLI for different environments can be found [here](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm).

Once we have installed the tool, we need to configure it to use the previously generated RSA Key to interact with out OCI Tenancy. In order to do that, we are going to create (or modify if it has been automatically created) the file `~/.oci/config` with the following keys:

```text
tenancy=<tenancy_ocid>
user=<user_ocid>
region=<region>
key_file=<user_rsa_path>
fingerprint=<user_rsa_fingerprint>
```

How to retrieve these values is explained in the [variables section](#variables).

### Kubernetes Command-Line Tool

In order to interact with our K8s Cluster using the Kubernetes API, we require a Kubernetes CLI; at this point, it's on your choice whether to use install the official CLI from Kubernetes (`kubectl`) or some other CLI tool as K9s (as I personally use).

- How to install `kubectl` in different environments is available in [here](https://kubernetes.io/docs/tasks/tools/#kubectl)
- How to install `k9s` in different environments is available in [here](https://k9scli.io/topics/install/)

## Usage

First, override all the variables by using a file in the root directory of our Terraform scripts with the defined variables in the [Requirement](#requirements) section with the name `env.tfvars`.

Then, in order to create the cluster, just run the following:

```shell
$ terraform apply -var-file="env.tfvars"
```

Check that everything is correct, and type `yes` on the required input. In some minutes, the cluster will be ready and a `kubeconfig` will be placed in the folder `generated`.

In order to start using this cluster, you can just export the `KUBECONFIG` environment variable to our current location and use your desired Kubernetes CLI Tool.

```shell
$ export KUBECONFIG=$(pwd)/generated/kubeconfig
$ k9s
```