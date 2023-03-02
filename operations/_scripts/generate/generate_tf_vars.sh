#!/bin/bash

set -e


# TODO: use templating
#    provide '.tf.tmpl' files in the 'operations/deployment' repo
#    and iterate over all of them to provide context with something like jinja
#    Example: https://github.com/mattrobenolt/jinja2-cli
#    jinja2 some_file.tmpl data.json --format=json

echo "In generate_tf_vars.sh"


GITHUB_ORG_NAME=$(echo $GITHUB_REPOSITORY | sed 's/\/.*//')
GITHUB_REPO_NAME=$(echo $GITHUB_REPOSITORY | sed 's/^.*\///')

if [ -n "$GITHUB_HEAD_REF" ]; then
  GITHUB_BRANCH_NAME=${GITHUB_HEAD_REF}
else
  GITHUB_BRANCH_NAME=${GITHUB_REF_NAME}
fi

GITHUB_IDENTIFIER="$($GITHUB_ACTION_PATH/operations/_scripts/generate/generate_identifier.sh)"
echo "GITHUB_IDENTIFIER: [$GITHUB_IDENTIFIER]"

GITHUB_IDENTIFIER_SS="$($GITHUB_ACTION_PATH/operations/_scripts/generate/generate_identifier_supershort.sh)"
echo "GITHUB_IDENTIFIER SS: [$GITHUB_IDENTIFIER_SS]"

if [ -z "$SUB_DOMAIN" ]; then
  SUB_DOMAIN="$GITHUB_IDENTIFIER"
fi

if [ -z "${EC2_INSTANCE_PROFILE}" ]; then
  EC2_INSTANCE_PROFILE="${GITHUB_IDENTIFIER}"
fi

echo "
lb_port = \"$LB_PORT\"

# the name of the operations repo environment directory
ops_repo_environment = \"deployment\"

# provide the name of the repo's org
app_org_name = \"${GITHUB_ORG_NAME}\"

# provide the name of the repo
app_repo_name = \"${GITHUB_REPO_NAME}\"

app_branch_name = \"${GITHUB_BRANCH_NAME}\"

# Path on the instance where the app will be cloned (do not include app_repo_name)
app_install_root = \"/home/ubuntu\"

# Logs
lb_access_bucket_name = \"${LB_LOGS_BUCKET}\"

# Security Group names
security_group_name = \"${GITHUB_IDENTIFIER}\"

# EC2
ec2_iam_instance_profile = \"${EC2_INSTANCE_PROFILE}\"
ec2_instance_public_ip = \"${EC2_INSTANCE_PUBLIC_IP}\"
ec2_instance_type = \"${EC2_INSTANCE_TYPE}\"

# AWS Specific
aws_resource_identifier = \"${GITHUB_IDENTIFIER}\"
aws_resource_identifier_supershort = \"${GITHUB_IDENTIFIER_SS}\"

# Domain+Sub Names
sub_domain_name = \"${SUB_DOMAIN}\"
domain_name = \"${DOMAIN_NAME}\"

# Cert stuff
root_domain = \"${ROOT_DOMAIN}\"
cert_arn = \"${CERT_ARN}\"
create_root_cert = \"${CREATE_ROOT_CERT}\"
create_sub_cert = \"${CREATE_SUB_CERT}\"
no_cert = \"${NO_CERT}\"

# VPC
create_vpc = \"${CREATE_VPC}\"

# Region
region = \"${AWS_DEFAULT_REGION}\"

# Route53
route53_zone_id = \"${ROUTE53_ZONE_ID}\"

aws_extra_tags = ${AWS_EXTRA_TAGS}


" > "${GITHUB_ACTION_PATH}/operations/deployment/terraform/terraform.tfvars"
