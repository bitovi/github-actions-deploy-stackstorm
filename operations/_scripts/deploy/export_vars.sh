#!/bin/bash
# Export variables to GHA

BO_OUT="$GITHUB_ACTION_PATH/operations/bo-out.env"

echo "GITHUB_OUTPUT"
echo "$GITHUB_OUTPUT"

if [ -f $BO_OUT ]; then
  cat $BO_OUT >> $GITHUB_OUTPUT
fi