#!/bin/bash
set -xe

echo "In clone-ansible-st2.sh"

echo ""
echo "================================="
echo "DEBUGGING"
echo "ST2_AUTH_USERNAME: ${ST2_AUTH_USERNAME}"
echo "ST2_AUTH_PASSWORD: ${ST2_AUTH_PASSWORD}"
echo "END DEBUGGING"
echo "================================="
echo ""

TF_DIR="${BITOPS_ENVROOT}/terraform"

ANSIBLE_DIR="${BITOPS_ENVROOT}/ansible"
rm -rf "${ANSIBLE_DIR}/ansible-st2"
echo "  ANSIBLE_DIR: ${ANSIBLE_DIR}"

echo "  cloning..."
git clone https://github.com/StackStorm/ansible-st2 $ANSIBLE_DIR/ansible-st2
echo "  cloning...Done"

echo "ls contents of ANSIBLE_DIR/ansible-st2"
ls $ANSIBLE_DIR/ansible-st2

echo "  copying files from ansible-st2"

echo "    $ANSIBLE_DIR/ansible-st2/roles/ -> $ANSIBLE_DIR/roles"
cp -r $ANSIBLE_DIR/ansible-st2/roles/* $ANSIBLE_DIR/roles

# TODO: for now, we need a custom playbook.yaml file to include the install role
#       there should be a way to merge/use the install role file without manually creating recreating the stackstorm.yml
# echo "    $ANSIBLE_DIR/ansible-st2/stackstorm.yml -> $ANSIBLE_DIR"
# cp $ANSIBLE_DIR/ansible-st2/stackstorm.yml $ANSIBLE_DIR

echo "  clean up"
rm -rf "${ANSIBLE_DIR}/ansible-st2"