#!/bin/bash

echo "In 01_prep_local_python.sh"
ansible-playbook prep.yml -i $ROOT_DIR/deployment/terraform/inventory.yaml