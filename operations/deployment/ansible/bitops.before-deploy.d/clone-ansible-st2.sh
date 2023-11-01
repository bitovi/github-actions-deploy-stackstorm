#!/bin/bash
set -e
echo ""
echo "###########################################################################"
echo "                  Initializing StackStorm installation"
echo "###########################################################################"
echo ""
echo "In clone-ansible-st2.sh"

TF_DIR="${BITOPS_ENVROOT}/terraform"

#ANSIBLE_DIR="${BITOPS_ENVROOT}/ansible"
ANSIBLE_DIR="${BITOPS_OPSREPO_ENVIRONMENT_DIR}"
rm -rf "${ANSIBLE_DIR}/ansible-st2"
echo "  ANSIBLE_DIR: ${ANSIBLE_DIR}"

echo "  Cloning..."
git clone https://github.com/StackStorm/ansible-st2 $ANSIBLE_DIR/ansible-st2
echo "  Cloning...Done"

if [[ -n $ST2_VERSION_TAG ]]; then 
  echo "  Switching to specific tag..."
  cd $ANSIBLE_DIR/ansible-st2 
  git fetch --tags
  git checkout $ST2_VERSION_TAG
  echo "  Switching to specific tag...Done"
fi

echo "  Copying files from ansible-st2"

echo "    $ANSIBLE_DIR/ansible-st2/roles/ -> $ANSIBLE_DIR/roles"
cp -r $ANSIBLE_DIR/ansible-st2/roles/* $ANSIBLE_DIR/roles

# TODO: for now, we need a custom playbook.yaml file to include the install role
#       there should be a way to merge/use the install role file without manually creating recreating the stackstorm.yml
# echo "    $ANSIBLE_DIR/ansible-st2/stackstorm.yml -> $ANSIBLE_DIR"
# cp $ANSIBLE_DIR/ansible-st2/stackstorm.yml $ANSIBLE_DIR

echo "  Clean up"
rm -rf "${ANSIBLE_DIR}/ansible-st2"
echo "Done with clone-ansible-st2.sh"