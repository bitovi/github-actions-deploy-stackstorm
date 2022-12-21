#!/bin/bash

echo "ls /opt/bitops_deployment"
ls /opt/bitops_deployment
echo "ls /opt/bitops_deployment/deployment"
ls /opt/bitops_deployment/deployment
echo "ls /opt/bitops_deployment/deployment/terraform"
ls /opt/bitops_deployment/deployment/terraform

TF_DIR="${BITOPS_ENVROOT}/terraform"
echo "TF_DIR"
echo "$TF_DIR"

echo "ls TF_DIR"
ls "$TF_DIR"

echo "TF_DIR/inventory.yaml"
cat "$TF_DIR/inventory.yaml"

echo "Waiting for instances to be ready..."
python3 $BITOPS_TEMPDIR/_scripts/ansible/wait-for-inventory-hosts.py