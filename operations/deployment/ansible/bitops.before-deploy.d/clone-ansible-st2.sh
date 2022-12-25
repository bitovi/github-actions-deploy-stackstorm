#!/bin/bash
set -xe

echo "In clone-ansible-st2.sh"

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

echo "ls ANSIBLE_DIR before"
ls $ANSIBLE_DIR
echo "ls ANSIBLE_DIR/roles before"
ls $ANSIBLE_DIR/roles

echo "    $ANSIBLE_DIR/ansible-st2/roles/ -> $ANSIBLE_DIR/roles"
cp -r $ANSIBLE_DIR/ansible-st2/roles/ $ANSIBLE_DIR/roles

echo "ls ANSIBLE_DIR after"
ls $ANSIBLE_DIR
echo "ls ANSIBLE_DIR/roles after"
ls $ANSIBLE_DIR/roles


# echo "    $ANSIBLE_DIR/ansible-st2/stackstorm.yml -> $ANSIBLE_DIR"
# cp $ANSIBLE_DIR/ansible-st2/stackstorm.yml $ANSIBLE_DIR

echo "clean up"
rm -rf "${ANSIBLE_DIR}/ansible-st2"