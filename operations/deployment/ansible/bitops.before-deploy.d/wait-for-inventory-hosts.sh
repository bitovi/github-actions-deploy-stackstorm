#!/bin/bash

TF_DIR="${ROOT_DIR}/${BITOPS_ENVIRONMENT}/terraform"
echo "TF_DIR"
echo "$TF_DIR"

echo "ls TF_DIR"
ls "$TF_DIR"

echo "TF_DIR/inventory.yaml"
cat "$TF_DIR/inventory.yaml"

echo "Waiting for instances to be ready..."
python3 $ROOT_DIR/_scripts/ansible/wait-for-inventory-hosts.py