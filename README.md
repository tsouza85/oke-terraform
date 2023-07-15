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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oke_version"></a> [oke\_version](#input\_oke\_version) | Value of the OKE version | `string` | `"v1.26.2"` | no |
| <a name="input_region"></a> [region](#input\_region) | Value of the 'Region' of the OCI instance | `string` | `"sa-saopaulo-1"` | no |
| <a name="input_region_oke"></a> [region\_oke](#input\_region\_oke) | Value of the 'Region' of the OCI instance | `string` | `"sa-saopaulo-1"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Value of the root Compartment OCID | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | Value of the User OCID | `string` | n/a | yes |
| <a name="input_user_rsa_fingerprint"></a> [user\_rsa\_fingerprint](#input\_user\_rsa\_fingerprint) | Value of the fingerprint of the RSA Public Key | `string` | n/a | yes |
| <a name="input_user_rsa_path"></a> [user\_rsa\_path](#input\_user\_rsa\_path) | Value of the path to the RSA Private Key | `string` | n/a | yes |

## Outputs

### Oracle Cloud Infrastructure (OCI) Access

In order to be able to perform operations against OCI, we need to create and import an RSA Key for API signing.

This can be easily performed with the following steps:

1. Make an `.oci` directory on your home folder:

```shell
$ mkdir $HOME/.oci
```

2. Generate a 2048-bit private key in a PEM format:

```shell
$ openssl genrsa -out $HOME/.oci/oci-rsa.pem 2048
```

3. Change permissions, so only you can read and write to the private key file:

```shell
$ chmod 600 $HOME/.oci/oci-rsa.pem
```

4. Generate the public key:

```shell
$ openssl rsa -pubout -in $HOME/.oci/oci-rsa.pem -out $HOME/.oci/oci-rsa-public.pem
$ cat $HOME/.oci/oci-rsa-public.pem
```

5. Add the public key to your OCI user account from `User Settings > API Keys`

### Oracle Cloud Infrastructure (OCI) CLI

We need a correctly configured OCI CLI to log against our to-be-created Kubernetes Cluster, as we will use the K8s login plugin to get a JWT for access.

Instructions on how to install the OCI CLI for different environments can be found [here](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm).

Once we have installed the tool, we need to configure it to use the previously generated RSA Key to interact with out OCI Tenancy. In order to do that, we are going to create (or modify if it has been automatically created) the file `$HOME/.oci/config` with the following keys:

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