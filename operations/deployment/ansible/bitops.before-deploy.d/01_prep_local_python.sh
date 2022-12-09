#!/bin/bash

echo "In 01_prep_local_python.sh"
ansible-playbook prep.yml -i $BITOPS_ENVROOT/terraform/inventory.yaml