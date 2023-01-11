#!/bin/bash

set -e

# TODO: use templating
#    provide '.tf.tmpl' files in the 'operations/deployment' repo
#    and iterate over all of them to provide context with something like jinja
#    Example: https://github.com/mattrobenolt/jinja2-cli
#    jinja2 some_file.tmpl data.json --format=json

echo "In ansible generate_bitops_config.sh"

echo "
ansible:
    cli:
      main-playbook: playbook.yml
      extra-vars: \"@extra-vars.yaml\"
    options:
      dryrun: false
" > "${GITHUB_ACTION_PATH}/operations/deployment/ansible/bitops.config.yaml"