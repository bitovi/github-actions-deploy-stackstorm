#!/bin/bash

echo "In deploy.sh"
GITHUB_REPO_NAME=$(echo $GITHUB_REPOSITORY | sed 's/^.*\///')

# Generate buckets identifiers and check them agains AWS Rules
export TF_STATE_BUCKET="$(/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_buckets_identifiers.sh tf | xargs)"
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/deploy/check_bucket_name.sh $TF_STATE_BUCKET
export LB_LOGS_BUCKET="$(/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_buckets_identifiers.sh lb | xargs)"
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/deploy/check_bucket_name.sh $LB_LOGS_BUCKET

# Generate buckets identifiers
export TF_STATE_BUCKET="$(/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_buckets_identifiers.sh tf | xargs)"
export LB_LOGS_BUCKET="$(/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_buckets_identifiers.sh lb | xargs)"

# Generate subdomain
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_subdomain.sh

# Generate the provider.tf file
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_provider.sh

# Generate terraform variables
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_tf_vars.sh

# Generate dot_env
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_dot_env.sh

# Generate app repo
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_app_repo.sh

# Generate `00_acm_create`
if [[ "$CREATE_DOMAIN" == "true" ]]; then
  /bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_acm_tf.sh
fi

if [ "$STACK_DESTROY" == "true" ]; then
  export BITOPS_TERRAFORM_STACK_ACTION="destroy"
  export BITOPS_ANSIBLE_SKIP_DEPLOY="true"
fi

if [[ "$GHA_TESTING" == "true" ]]; then
  echo "Quitting before BitOps invoke"
  exit 1
fi

set -x

# Ansible Extra vars file to override the default StackStorm configuration
if [[ -n $ST2_ANSIBLE_EXTRA_VARS_FILE ]]; then
  if [[ ! -f $GITHUB_WORKSPACE/$ST2_ANSIBLE_EXTRA_VARS_FILE ]]; then
    echo "Configuration error:"
    echo "File '$ST2_ANSIBLE_EXTRA_VARS_FILE' set in 'st2_ansible_extra_vars_file' does not exist!"
    exit 1
  fi

  cp $GITHUB_WORKSPACE/$ST2_ANSIBLE_EXTRA_VARS_FILE $GITHUB_ACTION_PATH/operations/deployment/ansible/
  # Ansible var files are prefixed with '@'
  export BITOPS_ANSIBLE_EXTRA_VARS="@$(basename $ST2_ANSIBLE_EXTRA_VARS_FILE)"
fi

# Bypass all the 'BITOPS_' ENV vars to docker
DOCKER_EXTRA_ARGS=""
for i in $(env | grep BITOPS_); do
  DOCKER_EXTRA_ARGS="${DOCKER_EXTRA_ARGS} -e ${i}"
done

echo "Running BitOps for env: $BITOPS_ENVIRONMENT"
docker run --rm --name bitops \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
-e AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}" \
-e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
-e TF_STATE_BUCKET="${TF_STATE_BUCKET}" \
-e TF_STATE_BUCKET_DESTROY="${TF_STATE_BUCKET_DESTROY}" \
-e CREATE_VPC="${CREATE_VPC}" \
-e ST2_AUTH_USERNAME="${ST2_AUTH_USERNAME}" \
-e ST2_AUTH_PASSWORD="${ST2_AUTH_PASSWORD}" \
-e ST2_PACKS="${ST2_PACKS}" \
${DOCKER_EXTRA_ARGS} \
-v $(echo $GITHUB_ACTION_PATH)/operations:/opt/bitops_deployment \
bitovi/bitops:2.4.0
