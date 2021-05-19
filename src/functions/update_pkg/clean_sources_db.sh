clean_sources_db() {
  local sources_db=$(cat /etc/mpm/sources.db)

  local action1=$(echo "${sources_db}" | sed 's|\\|\\\\|g' | sed 's|$|;|g' | xargs | sed 's| ||g')

  while echo "${action1}" | grep ';;' &> /dev/null; do
    action1=$(echo "${action1}" | sed 's|;;|;|g')
  done

  if [[ $(echo "${action1}" | head -c1) = ";" ]]; then
    new_action1=$(echo "${action1}" | sed "s|;||" | sed 's|;|\n|g')
  else
    new_action1=$(echo "${action1}" | sed 's|;|\n|g')
  fi


  echo "${new_action1}" | sudo tee /etc/mpm/sources.db &> /dev/null
}
