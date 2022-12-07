#!/bin/bash
set -xe

PROJECT_ROOT=/Volumes/Home/Bitovi/GithubActions/github-actions-deploy-stackstorm

rm -rf $PROJECT_ROOT/operations/deployment/ansible/ansible-st2

echo "In clone-ansible-st2.sh"
git clone https://github.com/StackStorm/ansible-st2 $PROJECT_ROOT/operations/deployment/ansible/ansible-st2
cp -r $PROJECT_ROOT/operations/deployment/ansible/ansible-st2/roles/ $PROJECT_ROOT/operations/deployment/ansible/roles
cp $PROJECT_ROOT/operations/deployment/ansible/ansible-st2/stackstorm.yml $PROJECT_ROOT/operations/deployment/ansible

rm -rf $PROJECT_ROOT/operations/deployment/ansible/ansible-st2