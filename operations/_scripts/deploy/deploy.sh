#!/bin/bash
set -x

echo "In deploy.sh"
GITHUB_REPO_NAME=$(echo $GITHUB_REPOSITORY | sed 's/^.*\///')

# Generate the tf state bucket
export TF_STATE_BUCKET="$(/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_tf_state_bucket.sh | xargs)"

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

# Generate bitops config
/bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_bitops_config.sh

# Generate `00_acm_create`
if [[ "$CREATE_DOMAIN" == "true" ]]; then
  /bin/bash $GITHUB_ACTION_PATH/operations/_scripts/generate/generate_acm_tf.sh
fi

TERRAFORM_COMMAND=""
TERRAFORM_DESTROY=""
if [ "$STACK_DESTROY" == "true" ]; then
  TERRAFORM_COMMAND="destroy"
  TERRAFORM_DESTROY="true"
  ANSIBLE_SKIP_DEPLOY="true"
fi

if [[ "$GHA_TESTING" == "true" ]]; then
  echo "Quitting before BitOps invoke"
  exit 1
fi

echo "Running BitOps for env: $BITOPS_ENVIRONMENT"
docker run --rm --name bitops \
-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}" \
-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}" \
-e AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN}" \
-e AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}" \
-e BITOPS_ENVIRONMENT="${BITOPS_ENVIRONMENT}" \
-e SKIP_DEPLOY_TERRAFORM="${SKIP_DEPLOY_TERRAFORM}" \
-e SKIP_DEPLOY_HELM="${SKIP_DEPLOY_HELM}" \
-e BITOPS_TERRAFORM_COMMAND="${TERRAFORM_COMMAND}" \
-e TERRAFORM_DESTROY="${TERRAFORM_DESTROY}" \
-e ANSIBLE_SKIP_DEPLOY="${ANSIBLE_SKIP_DEPLOY}" \
-e TF_STATE_BUCKET="${TF_STATE_BUCKET}" \
-e TF_STATE_BUCKET_DESTROY="${TF_STATE_BUCKET_DESTROY}" \
-e DEFAULT_FOLDER_NAME="_default" \
-e CREATE_VPC="${CREATE_VPC}" \
-e BITOPS_FAST_FAIL="${BITOPS_FAST_FAIL}" \
-e ST2_AUTH_USERNAME="${ST2_AUTH_USERNAME}" \
-e ST2_AUTH_PASSWORD="${ST2_AUTH_PASSWORD}" \
-e ST2_PACKS="${ST2_PACKS}" \
-v $(echo $GITHUB_ACTION_PATH)/operations:/opt/bitops_deployment \
bitovi/bitops:2.3.0