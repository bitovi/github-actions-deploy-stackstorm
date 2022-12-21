#!/bin/bash
set -xe

echo "In clone-ansible-st2.sh"

ANSIBLE_DIR="${ROOT_DIR}/${BITOPS_ENVIRONMENT}/ansible"
rm -rf "${ANSIBLE_DIR}/ansible-st2"
echo "  ANSIBLE_DIR: ${ANSIBLE_DIR}"

echo "  cloning..."
git clone https://github.com/StackStorm/ansible-st2 $ANSIBLE_DIR/ansible-st2
echo "  cloning...Done"

echo "ls contents of ANSIBLE_DIR/ansible-st2"
ls $ANSIBLE_DIR/ansible-st2

echo "  copying files from ansible-st2"

echo "    $ANSIBLE_DIR/ansible-st2/roles/ -> $ANSIBLE_DIR/roles"
cp -r $ANSIBLE_DIR/ansible-st2/roles/ $ANSIBLE_DIR/roles


echo "    $ANSIBLE_DIR/ansible-st2/stackstorm.yml -> $ANSIBLE_DIR"
cp $ANSIBLE_DIR/ansible-st2/stackstorm.yml $ANSIBLE_DIR

echo "clean up"
rm -rf "${ANSIBLE_DIR}/ansible-st2"