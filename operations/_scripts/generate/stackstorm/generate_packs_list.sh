#! /bin/bash
echo "In generate_packs_list.sh"

pack_selection=$(cat $GITHUB_WORKSPACE/$STACKSTORM_PACK_PATH | tr '\n' ' ' | tr '"' ' ')

IFS='- ' read -a pack_array <<< "$pack_selection"
# printf '%s\n' "${pack_array[@]}"

pack_list=
for i in "${pack_array[@]}"
do
   # Skip null items
    if [ -z "$i" ]; then
        continue
    fi
    pack_list="$pack_list,$i"
done

export STACKSTORM_BITOPS_PACKS_LIST="${pack_list[@]:1}"
echo $STACKSTORM_BITOPS_PACKS_LIST