#!/bin/bash

if [[ $TERRAFORM_COMMAND = "destroy" ]] && [[ $TF_STATE_BUCKET_DESTROY = true ]]; then
  echo "Destroying S3 buket --> $TF_STATE_BUCKET"
  aws s3 rb s3://$TF_STATE_BUCKET --force
else
  if [[ $TERRAFORM_COMMAND != "destroy" ]] && [[ $TF_STATE_BUCKET_DESTROY = true ]]; then
    echo "TF_STATE_BUCKET_DESTROY set to true, but Terraform action wasn't 'destroy'. Not destroying the state bucket ($TF_STATE_BUCKET)"
  fi
fi
