echo "In before script ansible_extravars.sh"


ANSIBLE_DIR="${BITOPS_ENVROOT}/ansible"
ST2_CONFIG_YAML_PATH="${ANSIBLE_DIR}/st2.config.yaml"
EXTRA_VARS_PATH="${ANSIBLE_DIR}/extra-vars.yaml"

if [ -n "$ST2_AUTH_USERNAME"]; then
  echo "    ST2_AUTH_USERNAME set. Updating username"

  # update the value of `st2_auth_username: testu` in extra-vars file`
  sed -i "s/^st2_auth_username=.*/st2_auth_username=${ST2_AUTH_USERNAME}/g" "$EXTRA_VARS_PATH"
fi
if [ -n "$ST2_AUTH_PASSWORD"]; then
  echo "    ST2_AUTH_PASSWORD set. Updating password"

  # update the value of `st2_auth_password: testp` in extra-vars file`
  sed -i "s/^st2_auth_password=.*/st2_auth_password=${ST2_AUTH_PASSWORD}/g" "$EXTRA_VARS_PATH"

fi


