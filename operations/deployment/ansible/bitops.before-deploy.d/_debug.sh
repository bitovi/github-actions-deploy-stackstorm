#!/bin/bash

echo "Current directory:"
pwd
ls -la

echo "BITOPS_ENVROOT: ${BITOPS_ENVROOT}"
ls -la "${BITOPS_ENVROOT}"

echo "BITOPS_ENVROOT/ansible: ${BITOPS_ENVROOT}/ansible"
ls -la "${BITOPS_ENVROOT}/ansible"

exit 1
