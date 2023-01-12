#!/bin/bash

set -e

echo "In ansible generate_bitops_config.sh"

cli="cli:
      main-playbook: playbook.yml"

if [[ -n $ST2_CONF_FILE ]]; then
cli="$cli
      extra-vars: \"${ST2_CONF_FILE}\""
fi


options="options:
      dryrun: false"


echo "
ansible:
    ${cli}
    ${options}
" > "${GITHUB_ACTION_PATH}/operations/deployment/ansible/bitops.config.yaml"