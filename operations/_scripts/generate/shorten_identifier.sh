#!/bin/bash

set -e

IDENTIFIER="$1"
final_id=""
MAX_IDENTIFIER_LENGTH=$2


if [ -z $MAX_IDENTIFIER_LENGTH ]; then
  MAX_IDENTIFIER_LENGTH=60
fi

# if identifier is less than or equal to 60, shorten
IDENTIFIER_LENGTH=${#IDENTIFIER}
if (( $IDENTIFIER_LENGTH < $MAX_IDENTIFIER_LENGTH )) ; then
  echo "$IDENTIFIER"
  exit 0
fi

re='^[-_]*([[:alnum:]]*).*'
if [[ $IDENTIFIER =~ $re ]]; then
  while [[ $IDENTIFIER =~ $re ]]; do
    if [ -z "${BASH_REMATCH[1]}" ]; then
      break;
    fi

    for current_match in "${BASH_REMATCH[@]}"; do
      if [ "$current_match" == "$IDENTIFIER" ]; then
        continue;
      fi

      # get first letter
      current_match_first_character=${current_match:0:1}
      # get last letter
      current_match_last_character=${current_match: -1}
      # gete match length
      current_match_length=${#current_match}
      
      if (( $current_match_length <= 3 )) ; then
        current_replace="${current_match}"
      else
        current_match_replace_length=$(expr $current_match_length - 2)
        current_replace="${current_match_first_character}${current_match_replace_length}${current_match_last_character}"
      fi

      if [ -n "$final_id" ]; then
        final_id="${final_id}-${current_replace}"
      else
        final_id="${current_replace}"
      fi

      IDENTIFIER=$(echo ${IDENTIFIER} | sed -e "s/${BASH_REMATCH[1]}//")
    done
  done
  echo "$final_id"
else
  echo "$IDENTIFIER"
fi