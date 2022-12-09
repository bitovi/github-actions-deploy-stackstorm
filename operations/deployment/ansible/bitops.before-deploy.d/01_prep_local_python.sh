#!/bin/bash

echo "In 01_prep_local_python.sh"

echo "DEBUG 1"
cat $BITOPS_ENVROOT/terraform/inventory.yaml
echo "DEBUG 1"

ansible-playbook prep.yml -i $BITOPS_ENVROOT/terraform/inventory.yaml