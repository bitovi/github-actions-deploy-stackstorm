#!/bin/bash
# Export variables to GHA

BO_OUT="$GITHUB_ACTION_PATH/operations/bo-out.env"

if [ -f $BO_OUT ]; then
  echo "BO_OUT ($BO_OUT)"
  cat $BO_OUT
  cat $BO_OUT >> $GITHUB_OUTPUT
else
  echo "BO_OUT not a file ($BO_OUT)"
fi