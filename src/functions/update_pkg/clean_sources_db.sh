clean_sources_db() {
  local sources_db=$(cat /etc/mpm/sources.db)

  local action1=$(echo "${sources_db}" | sed 's|\\|\\\\|g' | sed 's|$|;|g' | xargs | sed 's| ||g')

  while echo "${action1}" | grep ';;'; do
    action1=$(echo "${action1}" | sed 's|;;|;|g')
  done

  new_action1=$(echo "${action1}" | sed 's|;||' | rev | sed 's|;||' | rev | sed 's|;|\n|g')

  echo "${new_action1}" | sudo tee /etc/mpm/sources.db &> /dev/null
}
