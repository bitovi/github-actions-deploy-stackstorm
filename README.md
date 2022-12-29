# Deploy StackStorm

GitHub action to deploy [StackStorm](https://stackstorm.com/) to an AWS VM (EC2).

## Prerequisites
- An [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) and [Access Keys](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html)
- The following secrets should be added to your GitHub actions secrets:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - ST2_AUTH_USERNAME
  - ST2_AUTH_PASSWORD


## Example usage

Create `.github/workflow/deploy.yaml` with the following to build on push.

```yaml
name: Deploy ST2 Single VM with GHA

on:
  push:
    branches: [ main ]


jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - id: deploy
      name: Deploy
      uses: bitovi/github-actions-deploy-stackstorm@main
      with:
        aws_access_key_id: ${{ secrets.AWS_ACCESS_KEY_ID}}
        aws_secret_access_key: ${{ secrets.AWS_SECRET_ACCESS_KEY}}
        aws_default_region: us-east-1
        st2_auth_username: ${{ secrets.ST2_AUTH_USERNAME}}
        st2_auth_password: ${{ secrets.ST2_AUTH_PASSWORD}}
```

This will create the following resources in AWS:
- An EC2 instance
- A load balancer
- Security groups
- Optionally, a VPC with subnets

> For more details about what is created, see `operations/deployment/terraform/modules`

## Customizing

### Inputs

The following inputs can be used as `step.with` keys

| Name             | Type    | Default     | Description                        |
|------------------|---------|-------------|------------------------------------|
| `checkout` | Bool | true | Specifies if this action should checkout the code (i.e. whether or not to run the `uses: actions/checkout@v3` action prior to deploying so that the deployment has access to the repo files) |
| `aws_access_key_id` | String | |  AWS access key ID (Required) |
| `aws_secret_access_key` | String | |  AWS secret access key (Required) |
| `aws_session_token` | String | |  AWS session token |
| `aws_default_region` | String | us-east-1 |  AWS default region (Required) |
| `tf_state_bucket` | String | `${org}-${repo}-{branch}-tf-state` |  AWS S3 bucket to use for Terraform state. |
| `ec2_instance_profile` | String | |  The AWS IAM instance profile to use for the EC2 instance |
| `ec2_instance_type` | String | t2.medium |  The AWS EC2 instance type. |
| `stack_destroy` | Bool | false |  Set to "true" to Destroy the stack |
| `aws_resource_identifier` | String | `${org}-{repo}-{branch}` |  Set to override the AWS resource identifier for the deployment.  Use with destroy to destroy specific resources. |
| `aws_create_vpc` | Bool | false |  Whether an AWS VPC should be created in the action. |
| `st2_auth_username` | String | |  Username used by StackStorm standalone authentication |
| `st2_auth_password` | String | |  Password used by StackStorm standalone authentication |
| `st2_packs` | String |`"st2"` |  Comma separated list of packs to install. This flag does not work with a --python3 only pack.. If you modify this option, be sure to also include `st2` in the list. |

## Note about resource identifiers

Most resources will contain the tag GITHUB_ORG-GITHUB_REPO-GITHUB_BRANCH, some of them, even the resource name after. 
We limit this to a 60 characters string because some AWS resources have a length limit and short it if needed.

We use the kubernetes style for this. For example, kubernetes -> k(# of characters)s -> k8s. And so you might see some compressions are made.

For some specific resources, we have a 32 characters limit. If the identifier length exceeds this number after compression, we remove the middle part and replace it for a hash made up from the string itself. 

### S3 buckets naming

Buckets name can be made of up to 63 characters. If the length allows us to add `-tf-state`, we will do so. If not, a simple `-tf` will be added.

## Made with BitOps
[BitOps](https://bitops.sh) allows you to define Infrastructure-as-Code for multiple tools in a central place.  This action uses a BitOps [Operations Repository](https://bitops.sh/operations-repo-structure/) to set up the necessary Terraform and Ansible to create infrastructure and deploy to it.

## Future
In the future, this action will support more cloud providers (via [BitOps Plugins](https://bitops.sh/plugins/) like [AWS](https://github.com/bitops-plugins/aws)) such as
- [Google Cloud Platform](https://cloud.google.com/gcp)
- [Microsoft Azure](https://azure.microsoft.com/en-us/)
- [Nutanix](https://www.nutanix.com/)
- [Open Stack](https://www.openstack.org/)
- [VMWare](https://www.vmware.com/)
- etc

This action will also support multiple deployment types such as:
- [Kubernetes](https://github.com/StackStorm/stackstorm-k8s)
- Multi-VM

## Contributing
We would love for you to contribute to [bitovi/github-actions-deploy-docker-to-ec2](https://github.com/bitovi/github-actions-deploy-docker-to-ec2).   [Issues](https://github.com/bitovi/github-actions-deploy-docker-to-ec2/issues) and [Pull Requests](https://github.com/bitovi/github-actions-deploy-docker-to-ec2/pulls) are welcome!

## License
The scripts and documentation in this project are released under the [MIT License](https://github.com/bitovi/github-actions-deploy-docker-to-ec2/blob/main/LICENSE).

## Provided by Bitovi
[Bitovi](https://www.bitovi.com/) is a proud supporter of Open Source software.


## Need help?
Bitovi has consultants that can help.  Drop into [Bitovi's Community Slack](https://www.bitovi.com/community/slack), and talk to us in the `#devops` channel!

Need DevOps Consulting Services?  Head over to https://www.bitovi.com/devops-consulting, and book a free consultation.