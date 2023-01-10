#!/bin/bash

if [[ $TERRAFORM_DESTROY = true ]] && [[ $TF_STATE_BUCKET_DESTROY = true ]]; then
  echo "Destroying S3 buket --> $TF_STATE_BUCKET"
  aws s3 rb s3://$TF_STATE_BUCKET --force
else 
  if [[ $TERRAFORM_DESTROY != true ]] && [[ $TF_STATE_BUCKET_DESTROY = true ]]; then
    echo "TF_STATE_BUCKET_DESTROY set to true, but TERRAFORM_DESTROY wasn't. Not destroying the state bucket ($TF_STATE_BUCKET)"
  fi
fi
