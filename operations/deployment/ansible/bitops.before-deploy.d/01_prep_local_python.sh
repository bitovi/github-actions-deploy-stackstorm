#!/bin/bash

echo "In 01_prep_local_python.sh"
cat $BITOPS_ENVROOT/terraform/inventory.yaml


ansible-playbook prep.yml -i $BITOPS_ENVROOT/terraform/inventory.yaml