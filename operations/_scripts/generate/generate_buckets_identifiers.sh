#!/bin/bash

set -e

GITHUB_IDENTIFIER="$(echo $($GITHUB_ACTION_PATH/operations/_scripts/generate/generate_identifier.sh) | tr '[:upper:]' '[:lower:]')"

# Function: generate_identifiers
# Description: Generate all identifiers needs to poulate the IaC (terraform and ansible). Identifiers are a required component as cloud resources often have strict usage conventions that need to be appied to dynamic user input.
function generate_identifiers () {
  # Generate TF_STATE_BUCKET ID if empty 
  if [ -z "${TF_STATE_BUCKET}" ]; then
    if [[ ${#GITHUB_IDENTIFIER} < 55 ]]; then
      TF_STATE_BUCKET="${GITHUB_IDENTIFIER}-tf-state"
    else
      TF_STATE_BUCKET="${GITHUB_IDENTIFIER}-tf"
    fi
  else
    export TF_STATE_BUCKET=${TF_STATE_BUCKET}
  fi
  # Generate LB_LOGS_BUCKET ID
  if [[ ${#GITHUB_IDENTIFIER} < 59 ]]; then
    export LB_LOGS_BUCKET="${GITHUB_IDENTIFIER}-logs"
  else
    export LB_LOGS_BUCKET="${GITHUB_IDENTIFIER}-lg"
  fi
}
# Function: check_bucket_names
# Description: Runs a handful of RegEx to ensure strict usage requirements are followed.
function generate_bucket_names() {
  
  # check length of bucket name
  if [[ ${#1} -lt 3 || ${#1} -gt 63 ]]; then
    echo "Bucket name must be between 3 and 63 characters long."
    exit 1
  fi
  
  # check that bucket name consists only of lowercase letters, numbers, dots (.), and hyphens (-)
  if [[ ! $1 =~ ^[a-z0-9.-]+$ ]]; then
    echo "Bucket name can only consist of lowercase letters, numbers, dots (.), and hyphens (-)."
    exit 1
  fi
  
  # check that bucket name begins and ends with a letter or number
  if [[ ! $1 =~ ^[a-zA-Z0-9] ]]; then
    echo "Bucket name must begin with a letter or number."
    exit 1
  fi
  if [[ ! $1 =~ [a-zA-Z0-9]$ ]]; then
    echo "Bucket name must end with a letter or number."
    exit 1
  fi
  
  # check that bucket name does not contain two adjacent periods
  if [[ $1 =~ \.\. ]]; then
    echo "Bucket name cannot contain two adjacent periods."
    exit 1
  fi
  
  # check that bucket name is not formatted as an IP address
  if [[ $1 =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "Bucket name cannot be formatted as an IP address."
    exit 1
  fi
  
  # check that bucket name does not start with the prefix xn--
  if [[ $1 =~ ^xn-- ]]; then
    echo "Bucket name cannot start with the prefix xn--."
    exit 1
  fi
  
  # check that bucket name does not end with the suffix -s3alias
  if [[ $1 =~ -s3alias$ ]]; then
    echo "Bucket name cannot end with the suffix -s3alias."
    exit 1
  fi
}

generate_identifiers

generate_bucket_names $TF_STATE_BUCKET
generate_bucket_names $LB_LOGS_BUCKET

export TF_STATE_BUCKET=${TF_STATE_BUCKET}
export LB_LOGS_BUCKET=${LB_LOGS_BUCKET}