#!/bin/bash
set -xe

echo "In clone-ansible-st2.sh"

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

echo "ls TF_DIR/modules"
ls "$TF_DIR/modules"

echo "TF_DIR/inventory.yaml"
cat "$TF_DIR/inventory.yaml"



ANSIBLE_DIR="${BITOPS_ENVROOT}/ansible"
rm -rf "${ANSIBLE_DIR}/ansible-st2"
echo "  ANSIBLE_DIR: ${ANSIBLE_DIR}"

echo "  cloning..."
git clone https://github.com/StackStorm/ansible-st2 $ANSIBLE_DIR/ansible-st2
echo "  cloning...Done"

echo "ls contents of ANSIBLE_DIR/ansible-st2"
ls $ANSIBLE_DIR/ansible-st2

echo "  copying files from ansible-st2"

echo "ls ANSIBLE_DIR/roles ($ANSIBLE_DIR/roles) before"
ls $ANSIBLE_DIR/roles

echo "    $ANSIBLE_DIR/ansible-st2/roles/ -> $ANSIBLE_DIR/roles"
cp -r $ANSIBLE_DIR/ansible-st2/roles/ $ANSIBLE_DIR/roles

echo "ls ANSIBLE_DIR/roles ($ANSIBLE_DIR/roles) after"
ls $ANSIBLE_DIR/roles


# echo "    $ANSIBLE_DIR/ansible-st2/stackstorm.yml -> $ANSIBLE_DIR"
# cp $ANSIBLE_DIR/ansible-st2/stackstorm.yml $ANSIBLE_DIR

echo "clean up"
rm -rf "${ANSIBLE_DIR}/ansible-st2"