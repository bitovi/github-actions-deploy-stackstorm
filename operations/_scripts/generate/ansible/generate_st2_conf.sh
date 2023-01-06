#! /bin/bash
echo "In generate_st2_conf.sh"

if [[ -n $ST2_CONF_PATH ]]; then
    cp $GITHUB_WORKSPACE/$ST2_CONF_PATH $GITHUB_ACTION_PATH/operations/deployment/ansible/vars/st2.conf
fi