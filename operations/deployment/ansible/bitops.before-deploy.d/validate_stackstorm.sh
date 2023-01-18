#!/bin/bash

set -ex

# This file is needed as ST2_PACKS does have an action default however it is possible for a user to set this effectively null "" which will cause issues during the stackstorm installation.

if [[ $ST2_PACKS == "" ]]; then
    export ST2_PACKS="st2"
fi