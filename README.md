# Github Action: Deploy StackStorm

[![LICENSE](https://img.shields.io/badge/license-MIT-green)](LICENSE.md)
[![Latest Release](https://img.shields.io/github/v/release/bitovi/github-actions-deploy-stackstorm)](https://github.com/bitovi/github-actions-deploy-stackstorm/releases)
![GitHub closed issues](https://img.shields.io/github/issues-closed/bitovi/github-actions-deploy-stackstorm)
![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/bitovi/github-actions-deploy-stackstorm)
[![Discrod Community](https://img.shields.io/discord/1007137664606150746?logo=discord&label=Discord)](https://discord.gg/zAHn4JBVcX)

![alt](https://bitovi-gha-pixel-tracker-deployment-main.bitovi-sandbox.com/pixel/fBfJvGWta6ZyohS-moZ34)
## Action Summary
This action deploys a Stackstorm instance to an AWS VM (EC2) with [Terraform](operations/deployment/terraform/modules) and [Ansible](https://github.com/stackstorm/ansible-st2).  

If you would like to deploy a backend app/service, check out our other actions:
| Action | Purpose |
| ------ | ------- |
| [Deploy Docker to EC2](https://github.com/marketplace/actions/deploy-docker-to-aws-ec2) | Deploys a repo with a Dockerized application to a virtual machine (EC2) on AWS |
| [Deploy React to GitHub Pages](https://github.com/marketplace/actions/deploy-react-to-github-pages) | Builds and deploys a React application to GitHub Pages. |
| [Deploy static site to AWS (S3/CDN/R53)](https://github.com/marketplace/actions/deploy-static-site-to-aws-s3-cdn-r53) | Hosts a static site in AWS S3 with CloudFront |
<br/>

**And more!**, check our [list of actions in the GitHub marketplace](https://github.com/marketplace?category=&type=actions&verification=&query=bitovi)

# Need help or have questions?
This project is supported by [Bitovi, A DevOps consultancy](https://www.bitovi.com/services/devops-consulting).

You can **get help or ask questions** on our [Discord channel](https://discord.gg/zAHn4JBVcX)! Come hang out with us; We love discussing solutions!

Or, you can hire us for training, consulting, or development. [Set up a free consultation](https://www.bitovi.com/services/devops-consulting).

## Prerequisites
- An [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) and [Access Keys](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
- The following secrets should be added to your GitHub actions secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `ST2_AUTH_USERNAME`
  - `ST2_AUTH_PASSWORD`

:warning: In the latest release, some variables were replaced.  Old one will not work.

| Old variable | Replaced By | 
| - | - | 
| aws_extra_tags | aws_additional_tags | 
| aws_ec2_instance_profile | aws_ec2_iam_instance_profile |
| aws_ec2_instance_vol_size | aws_ec2_instance_root_vol_size | 
| aws_domain_name | aws_r53_domain_name | 
| aws_sub_domain_name | aws_r53_sub_domain_name | 
| aws_root_domain_deploy | aws_r53_root_domain_deploy | 
| aws_cert_arn | aws_r53_cert_arn | 
| aws_create_root_cert | aws_r53_create_root_cert | 
| aws_create_sub_cert | aws_r53_create_sub_cert | 
| aws_no_cert | aws_r53_enable_cert :warning:  |  

> :warning: `aws_no_cert` has the opossite value of `aws_r53_enable_cert`. Cert lookup is set to `true` by default, and won't fail if it can't find any.
<br/>

## Example usage

Create a Github Action Workflow `.github/workflow/deploy-st2.yaml` with the following to build on push to the `main` branch.

```yaml
# Deploy ST2 Single VM with GHA
name: CD

on:
  push:
    branches: [ main ]

jobs:
  deploy-st2:
    runs-on: ubuntu-latest
    steps:
    - id: deploy-st2
      name: Deploy StackStorm
      # NOTE: we recommend pinning to the latest numeric version
      # See: https://github.com/bitovi/github-actions-deploy-stackstorm/releases
      uses: bitovi/github-actions-deploy-stackstorm@v0.4.0
      with:
        aws_default_region: us-east-1
        aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID}}
        aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY}}
        st2_auth_username: ${{ secrets.ST2_AUTH_USERNAME}}
        st2_auth_password: ${{ secrets.ST2_AUTH_PASSWORD}}
        st2_packs: "st2,aws,github"
```

This will create the following resources in AWS:
- An EC2 instance
- Route53 records
- A load balancer
- Security groups (ports `80`, `443`, `22`)
- Optionally, use an existing or define a new VPC with subnets (see `aws_create_vpc`)

> For more details about what is created, see [operations/deployment/terraform/modules](operations/deployment/terraform/modules/)

## Customizing

### Inputs
1. [Action Defaults](#action-defaults-inputs)
2. [AWS Configuration](#aws-configuration-inputs)
4. [EC2](#ec2-instance-config)
5. [Stackstorm inputs](#stackstorm-inputs)
6. [Stack Management](#stack-management)
7. [Domains and certificates](#domains-and-certificates)
8. [VPC](#vpc-configuration)
9. [Advanced Options](#advanced-options)

### Outputs
1. [Action Outpus](#action-outputs)


The following inputs can be used as `steps.with` keys:
<br/>
<br/>

#### **Action defaults Inputs**
| Name             | Type    | Description                        | 
|------------------|---------|------------------------------------|
| `checkout` | Boolean | Set to `false` if the code is already checked out. (Default is `true`). |
<hr/>
<br/>

#### **AWS Configuration Inputs**
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_access_key_id` | String | AWS access key ID |
| `aws_secret_access_key` | String | AWS secret access key |
| `aws_session_token` | String | AWS session token |
| `aws_default_region` | String | AWS default region. Defaults to `us-east-1` |
| `aws_resource_identifier` | String | Set to override the AWS resource identifier for the deployment. Defaults to `${GITHUB_ORG_NAME}-${GITHUB_REPO_NAME}-${GITHUB_BRANCH_NAME}`. |
| `aws_additional_tags` | JSON | Add additional tags to the terraform [default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider), any tags put here will be added to all provisioned resources. |
<hr/>
<br/>

 #### **EC2 Instance config** 
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_ec2_instance_type` | String | The AWS IAM instance type to use. Default is `t3.medium`. See [this list](https://aws.amazon.com/ec2/instance-types/) for reference. |
| `aws_ec2_instance_root_vol_size` | Integer | Define the volume size (in GiB) for the root volume on the AWS Instance. Defaults to `8`. | 
| `aws_ec2_instance_root_vol_preserve` | Boolean | Set this to true to avoid deletion of root volume on termination. Defaults to `false`. | 
| `aws_ec2_security_group_name` | String | The name of the EC2 security group. Defaults to `SG for ${aws_resource_identifier} - EC2`. |
| `aws_ec2_iam_instance_profile` | String | The AWS IAM instance profile to use for the EC2 instance. Will create one if none provided with the name `aws_resource_identifier`. |
| `aws_ec2_create_keypair_sm` | Boolean | Generates and manages a secret manager entry that contains the public and private keys created for the ec2 instance. Defaults to `false`. |
| `aws_ec2_instance_public_ip` | Boolean | Add a public IP to the instance or not. Defaults to `true`. |
| `aws_ec2_additional_tags` | JSON | Add additional tags to the terraform [default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider), any tags put here will be added to ec2 provisioned resources.|
<hr/>
<br/>

 #### **Stackstorm inputs** 
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `st2_auth_username` | String | Username used by StackStorm standalone authentication. Set as a secret in GH Actions. |
| `st2_auth_password` | String | Password used by StackStorm standalone authentication. Set as a secret in GH Actions. |
| `st2_packs` | String | Comma separated list of packs to install. If you modify this option, be sure to also include `st2` in the list. Defaults to `"st2"` |
| `st2_ansible_extra_vars_file` | String | Relative path from project root to Ansible vars file. If you'd like to adjust more advanced configuration; st2 version, st2.conf, RBAC, chatops, auth, etc. See https://github.com/stackStorm/ansible-st2#variables for the full list of settings. The Ansible vars will take higher precedence over the GHA inputs. |
| `st2_version_tag` | String | Stackstorm Ansible release tag to use. See https://github.com/StackStorm/ansible-st2/releases |
<hr/>
<br/>

#### **Stack Management** 
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `tf_stack_destroy` | Boolean || Set to `true` to Destroy the created AWS infrastructure for this instance. Defaults to  `false` .|
| `tf_state_file_name` | String | `tf-state-aws` | Change this to be anything you want to. Carefull to be consistent here. A missing file could trigger recreation, or stepping over destruction of non-defined objects. |
| `tf_state_file_name_append` | String | | Appends a string to the tf-state-file name. Setting this to `unique` will generate `tf-state-aws-unique`. (Can co-exist with `tf_state_file_name`) |
| `tf_state_bucket` | String | `${aws_resource_identifier}-tf-state` | AWS S3 bucket to use for Terraform state. By default, a new deployment will be created for each unique branch. Hardcode if you want to keep a shared resource state between the several branches. |
| `tf_state_bucket_destroy` | Boolean | `false` | Force purge and deletion of `tf_state_bucket` defined. Any file contained there will be destroyed. `tf_stack_destroy` must also be `true` |
<hr/>
<br/>

#### **Domains and certificates** 
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_r53_domain_name` | String | Define the root domain name for the application. e.g. bitovi.com'. |
| `aws_r53_sub_domain_name` | String | Define the sub-domain part of the URL. Defaults to `aws_resource_identifier`. |
| `aws_r53_root_domain_deploy` | Boolean | Deploy application to root domain. Will create root and www records. Default is `false`. |
| `aws_r53_enable_cert` | Boolean | Set this to true if you wish to manage certificates through AWS Certificate Manager with Terraform. **See note**. Default is `false`. | 
| `aws_r53_cert_arn` | String | Define the certificate ARN to use for the application. **See note**. |
| `aws_r53_create_root_cert` | Boolean | Generates and manage the root cert for the application. **See note**. Default is `false`. |
| `aws_r53_create_sub_cert` | Boolean | Generates and manage the sub-domain certificate for the application. **See note**. Default is `false`. |
| `aws_r53_additional_tags` | JSON | Add additional tags to the terraform [default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider), any tags put here will be added to R53 provisioned resources.|
<hr/>
<br/>

#### **VPC configuration**
| Name             | Type    | Description                        |
|------------------|---------|------------------------------------|
| `aws_vpc_create` | Boolean | Define if a VPC should be created. Defaults to `false`. |
| `aws_vpc_name` | String | Define a name for the VPC. Defaults to `VPC for ${aws_resource_identifier}`. |
| `aws_vpc_cidr_block` | String | Define Base CIDR block which is divided into subnet CIDR blocks. Defaults to `10.0.0.0/16`. |
| `aws_vpc_public_subnets` | String | Comma separated list of public subnets. Defaults to `10.10.110.0/24`|
| `aws_vpc_private_subnets` | String | Comma separated list of private subnets. If no input, no private subnet will be created. Defaults to `<none>`. |
| `aws_vpc_availability_zones` | String | Comma separated list of availability zones. Defaults to `aws_default_region+<random>` value. If a list is defined, the first zone will be the one used for the EC2 instance. |
| `aws_vpc_id` | String | **Existing** AWS VPC ID to use. Accepts `vpc-###` values. |
| `aws_vpc_subnet_id` | String | **Existing** AWS VPC Subnet ID. If none provided, will pick one. (Ideal when there's only one). |
| `aws_vpc_enable_nat_gateway` | Boolean | Adds a NAT gateway for each public subnet. Defaults to `false`. |
| `aws_vpc_single_nat_gateway` | Boolean | Toggles only one NAT gateway for all of the public subnets. Defaults to `false`. |
| `aws_vpc_external_nat_ip_ids` | String | **Existing** comma separated list of IP IDs if reusing. (ElasticIPs). |
| `aws_vpc_additional_tags` | JSON | Add additional tags to the terraform [default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider), any tags put here will be added to vpc provisioned resources.|
<hr/>
<br/>

#### **Action Outputs**
| Name             | Description                        |
|------------------|------------------------------------|
| `aws_vpc_id` | The selected VPC ID used. |
| `vm_url` | The URL of the generated app. |
| `instance_endpoint` | The URL of the generated ec2 instance. |
| `ec2_sg_id` | SG ID for the EC2 instance. |

### Note about AWS resource identifiers
Most resources will contain the tag `GITHUB_ORG-GITHUB_REPO-GITHUB_BRANCH` to make them unique. Because some AWS resources have a length limit, we shorten identifiers to a `60` characters max string.

We use the Kubernetes style for this. For example, `Kubernetes` -> `k(# of characters)s` -> `k8s`. And so you might see how compressions are made.

For some specific resources, we have a `32` characters limit. If the identifier length exceeds this number after compression, we remove the middle part and replace it with a hash made up of the string itself.

### S3 buckets naming
Bucket names can be made of up to 63 characters. If the length allows us to add `-tf-state`, we will do so. If not, a simple `-tf` will be added.

## Domain and Certificates - Only for AWS Managed domains with Route53

As a default, the application will be deployed and the ELB public URL will be displayed.

If `aws_domain_name` is defined, we will look up for a certificate with the name of that domain (eg. `example.com`). We expect that certificate to contain both `example.com` and `*.example.com`. Resulting URL will be `aws_sub_domain.aws_domain_name`

If no certificate is available for `aws_domain_name`, then set up `no_cert` to true. 

If you want to use an already created certificate, or prefer to manage it manually, you can set up `aws_cert_arn`. 
Check the [AWS notes](https://docs.aws.amazon.com/acm/latest/userguide/gs-acm-list.html) for how to find the certificate ARN in AWS.

Setting `aws_create_root_cert` to `true` will create this certificate with both `example.com` and `*.example.com` for you, and validate them. (DNS validation).

Setting `aws_create_sub_cert` to `true` will create a certificate **just for the subdomain**, and validate it.

> :warning: Be very careful here! **Created certificates are fully managed by Terraform**. Therefore **they will be destroyed upon stack destruction**.

To change a certificate (root_cert, sub_cert, ARN or pre-existing root cert), you must first set the `no_cert` flag to true, run the action, then set the `no_cert` flag to false, add the desired settings and excecute the action again. (**This will destroy the first certificate.**)

This is necessary due to a limitation that prevents certificates from being changed while in use by certain resources.

### Advanced StackStorm configuration with Ansible vars
This action runs [`ansible-st2`](https://github.com/stackStorm/ansible-st2) roles under the hood. You can customize the Ansible configuration by creating a yaml file in your repo. This file will be passed to the Ansible playbook as extra vars. See the [Ansible-st2](https://github.com/stackStorm/ansible-st2#variables) documentation for a full list of available options.

Here is an example `st2_vars.yaml` pinning the stackstorm to `v3.8.0`, installing several packs from [StackStorm Exchange](https://exchange.stackstorm.org) and configuring `st2.conf` with extra settings for `garbagecollector`:

```yaml
st2_version: "3.8.0"

# Install specific pack versions from StackStorm Exchange
st2_packs:
  - st2
  - aws=1.2.0
  - github=2.1.3

# https://github.com/StackStorm/st2/blob/master/conf/st2.conf.sample
st2_config:
  garbagecollector:
    # Action executions and related objects (live actions, action output objects) older than this value (days) will be automatically deleted. Defaults to None (disabled).
    action_executions_ttl = 90
```

Example GHA deployment job referencing the Ansible `st2_vars.yaml` file:
```yaml
jobs:
  deploy-st2:
    runs-on: ubuntu-latest
    steps:
    - id: deploy-st2-advanced
      name: Deploy StackStorm with extra Ansible vars
      uses: bitovi/github-actions-deploy-stackstorm@v0.4.1
      with:
        aws_default_region: us-east-1
        aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID}}
        aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY}}
        st2_auth_username: ${{ secrets.ST2_AUTH_USERNAME}}
        st2_auth_password: ${{ secrets.ST2_AUTH_PASSWORD}}
        # Pass the Ansible vars file
        st2_ansible_extra_vars_file: "st2_vars.yaml"
```

We encourage to keep your infrastructure codified!

## Made with BitOps
[BitOps](https://bitops.sh/) allows you to define Infrastructure-as-Code for multiple tools in a central place. This action uses BitOps Docker container with prebuilt deployment tools and [Operations Repository Structure](https://bitops.sh/operations-repo-structure/) to organize the necessary Terraform and Ansible steps, create infrastructure and deploy to it.

### Extra BitOps Configuration
You can pass additional `BITOPS_` ENV variables to adjust the deployment behavior.
```yaml
- name: Deploy StackStorm to AWS (dry-run)
  uses: bitovi/github-actions-deploy-stackstorm@v0.4.1
  env:
    # Extra BitOps configuration:
    BITOPS_LOGGING_LEVEL: INFO
    # Extra Terraform configuration:
    # https://bitops.sh/tool-configuration/configuration-terraform/#terraform-bitops-schema
    BITOPS_TERRAFORM_SKIP_DEPLOY: true
    # Extra Ansible configuration:
    # https://bitops.sh/tool-configuration/configuration-ansible/#cli-configuration
    BITOPS_ANSIBLE_DRYRUN: true
  with:
    aws_default_region: us-east-1
    aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    st2_auth_username: ${{ secrets.ST2_AUTH_USERNAME }}
    st2_auth_password: ${{ secrets.ST2_AUTH_PASSWORD}}
```
In this example, we instruct BitOps to run a `terraform plan` instead of `terraform apply` and to run Ansible in `--check` mode, additionally, we set the BitOps container logging level to `DEBUG`.

## Future
In the future, this action may support multiple deployment types such as:
- [Kubernetes](https://github.com/StackStorm/stackstorm-k8s)
- Multi-VM

This action is still in its early stages, so we welcome your feedback! [Open an issue](issues/) if you have a feature request.

## Contributing
We would love for you to contribute to [bitovi/github-actions-deploy-stackstorm](/).   [Issues](issues/) and [Pull Requests](pulls/) are welcome!

## Provided by Bitovi
[Bitovi](https://www.bitovi.com/) is a proud supporter of Open Source software.

## Need help or have questions?
You can **get help or ask questions** on [Discord channel](https://discord.gg/zAHn4JBVcX)! Come hangout with us!

Or, you can hire us for training, consulting, or development. [Set up a free consultation](https://www.bitovi.com/devops-consulting).
