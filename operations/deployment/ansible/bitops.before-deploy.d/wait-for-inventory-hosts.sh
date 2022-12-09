#!/bin/bash
echo "I am a before ansible lifecycle script!"
python3 $ROOT_DIR/_scripts/ansible/wait-for-inventory-hosts.py