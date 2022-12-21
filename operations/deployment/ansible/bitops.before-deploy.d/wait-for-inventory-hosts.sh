#!/bin/bash

echo "Waiting for instances to be ready..."
python3 $BITOPS_TEMPDIR/_scripts/ansible/wait-for-inventory-hosts.py